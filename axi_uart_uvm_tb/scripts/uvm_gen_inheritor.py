import sys
import os

if len(sys.argv) < 2:
    sys.exit(1)

file_path = sys.argv[1]
class_name = sys.argv[2]
base_class = sys.argv[3]

os.makedirs(os.path.dirname(file_path), exist_ok=True)

content = f"""\
`include "dependencies.svh"

class {class_name} extends {base_class};

    `uvm_component_utils({class_name})

    function new(string name="{class_name}", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
endclass

"""

with open(file_path, "w") as f:
    f.write(content)