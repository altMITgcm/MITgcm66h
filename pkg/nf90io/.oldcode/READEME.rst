NF90IO .oldcode
===============

This is some old code from the original implimentation of this package.  This was meant to be called via `model/src/write_state.F`, and there was meant to be a `data.nf90io` that allowed the user to set the netcdf filename.  

However, the maintainers suggested the right way to do this was to make `nf90io` an option of `pkg/diagnostics`. So, that is how the package is now implimented.  This code is kept here in case we decide to re-add the ability to dump the state variables.  
