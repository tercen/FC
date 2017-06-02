# Image Cytometry (IC)

Tercen operators for IC are available in this repository. The flowCore bioconductor package is the basis of most of the Tercen operators. Each operator has its own readme in each of the operators directory.

* transformer operator is found in the ``transformer_op`` directory
* density operator is found in the ``density_op`` directory
* rectangle gate operator is under developement and is found in the ``rectangle_gate_op`` 

Example data is found in ``data`` folder
Data to upload to Tercen is generated using the the ``make_data.R`` script. This script generates files in the ``data`` folder.


# flowCore classes

The ``frame`` class is used in most operator, this is to faciliate the use of flowCore function/primitives .

# Design decisions

For Tercen operators, I decided to use the same structure as in flowCore i.e. the variables as columns and observations as rows.