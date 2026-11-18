function ipynb2py --description "Convert Jupyter Notebook files to Pyhton files"
    command uv run jupytext --to py:percent --update-metadata '{"jupytext": {"cell_markers": "\"\"\""}}' $argv[1]
end
