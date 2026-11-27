function ipynb2py --description "Convert Jupyter Notebook files to Python files"
    command uvx jupytext --to py:percent --update-metadata '{"jupytext": {"cell_markers": "\"\"\""}}' $argv[1]
end
