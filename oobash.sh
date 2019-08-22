declare -A oob_parents
let oob_next_id=1

oob_err() {
    echo "!! $@" 1>&2
}

oob_debug() {
    if [ -n "$OOB_DEBUG" ]; then
        local depth=$((${#FUNCNAME[*]} * 2 - 2))
        local dashes=$(printf '%.0s-' $(seq $depth))
        echo "${dashes}$@" 1>&2
    fi
}

new() {
    local class=$1
    local name=$2
    if [[ -z "$class" || -z "$name" ]]; then
        oob_err "'new' requires two arguments (class and name)"
    fi
    if [ "$(type -t "$class")" !=  "function" ]; then
        oob_err "Can't instantiate '$class'"
    fi
    local object_definition=$(declare -f object)
    local instance_definition="${name}${object_definition#object}"
    # semicolons because eval is going to mash this into one line
    echo "declare -A oob_object_${name};"
    echo "$instance_definition;"
    echo "oob_parents[$name]=$class;"
    echo "$name __class = $class;"
    echo "$name __id = $oob_next_id;"
    echo "let oob_next_id++;"
    echo "$name __constructor;"
}

object() {
    local this_object=${FUNCNAME[0]}
    if [ -z "$self" ]; then local self="$this_object"; fi
    local prop_name="$1"
    if [ -z "$prop_name" ]; then echo $self; return 0; fi
    shift

    oob_debug "[$this_object] $prop_name $@"
    local property="oob_object_${this_object}[$prop_name]"
    if [ "$1" == "=" ]; then
        shift
        oob_debug "assigning $self's $prop_name"
        $self __assign $prop_name "$@"
    else
        local value="${!property}"
        local type=$(type -t "$property")
        if read -t 0 -u 0; then
            oob_debug "defining $self's $prop_name method"
            local method_definition
            read -d '' method_definition
            source <(echo -e "$property () {\n$method_definition\n}")
        elif [ "$type" == "function" ]; then
            oob_debug "calling $this_object's $prop_name method for $self ($@)"
            self=$self "$property" "$@"
        elif [ -n "$value" ]; then
            oob_debug "returning $self's $prop_name value ($value)"
            echo "$value"
        elif [ -n "${oob_parents[$this_object]}" ]; then
            oob_debug "searching $self's parent for $prop_name"
            self=$self super=${oob_parents[$this_object]} "${oob_parents[$this_object]}" $prop_name "$@"
        else
            oob_err "Property not found: $prop_name"
        fi
    fi
}

object __constructor <<'EOF'
    :
EOF

object __assign <<'EOF'
    local property=$1
    shift
    eval "oob_object_${self}[$property]=$(printf %q \"$@\")"
EOF

oob_prototype_cnfhandle ()
{
    if false; then
        echo "placeholder for parsing stuff"
    elif [ -n "$oob_old_cnfhandle" ]; then
        oob_old_cnfhandle "$@"
    else
        echo "bash: $1: command not found (handled)"
    fi
    return 127
}

oob_cnfhandle="$(declare -f oob_prototype_cnfhandle)"
oob_cnfhandle="command_not_found_handle${oob_cnfhandle#oob_prototype_cnfhandle}"
if [ -z "$oob_old_cnfhandle" ]; then
    oob_old_cnfhandle="$(declare -f command_not_found_handle)"
fi
if [ "$oob_old_cnfhandle" == "$oob_cnfhandle" ]; then
    unset oob_old_cnfhandle
fi
if [ -n "$oob_old_cnfhandle" ]; then
    source <(echo "oob_old_cnfhandle ${oob_old_cnfhandle#command_not_found_handle}")
fi
source <(echo "$oob_cnfhandle")
