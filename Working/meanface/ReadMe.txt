"Generic Active Appearance Models Revisited", accepted in ACCV 2012.

This CODE reproduces the results reported in the paper above.
Code tested on 64-bit Windows 7 machine running MATLAB 7.11.0 (R2012a).

###IMPORTANT################################################################

If you do not have XM2VTs or MultiPie database in yout possession then probably the 
easiest thing to do is go to General Fitting


###########################################################################
DATA

XM2VTS database    : http://www.ee.surrey.ac.uk/CVSSP/xm2vtsdb/
Annotations of XM2VTS should be downloaded from 
http://www-prima.inrialpes.fr/FGnet/data/07-XM2VTS/xm2vts_markup.html


Multi-PIE database : http://www.multipie.org/
Annotations are provided by the creators of Multipie (could send them an email)


###########################################################################
CODE

Please add the 'ACCV2012' folder together with all its subfolders to the
current matlab path.

---------------------------------------------------------------------------
Reproducing the experiments:

- 'Fit_POICA_AOM_XM2VTS' corresponds to Fig. (2) in the paper 

For this script to work, it is necessary that the XM2VTS image and 
annotation files corresponding to the file names stored in 
'ACCV2012\02_data\01_XM2VTS\02_test_images\image_list.mat' and 
'ACCV2012\02_data\01_XM2VTS\02_test_images\shape_list.mat' 
are saved in 'ACCV2012\02_data\01_XM2VTS\02_test_images\'.

- 'Fit_POICA_AOM_MultiPIE_identity' corresponds to Fig. (3a) in the paper 
          
As before, these script require that the Multi-PIE image and annotation 
files corresponding to the file names stored in 
'ACCV2012\02_data\02_Multi-PIE\02_test_images\01_identity\image_list.mat' and 
'ACCV2012\02_data\02_Multi-PIE\02_test_images\01_identity\shape_list.mat' are 
stored in 'ACCV2012\02_data\01_Multi-PIE\02_test_images\'.

- 'Fit_POICA_AOM_MultiPIE_expressions' corresponds to Fig. (3b) in the paper

Similarly, the Multi-PIE image and annotation files corresponding to the 
file names stored in 'ACCV2012\02_data\02_Multi-PIE\02_test_images\02_expressions\image_list.mat' 
and 'ACCV2012\02_data\02_Multi-PIE\02_test_images\02_expressions\shape_list.mat' 
have to be stored in 'ACCV2012\02_data\01_Multi-PIE\02_test_images\02_expressions\' 
for this script to work.

- 'Fit_POICA_AOM_MultiPIE_pose' corresponds to Fig. (3c) in the paper

For this script to work, ensure that Multi-PIE image and annotation files corresponding to 
the file names stored in 'ACCV2012\02_data\02_Multi-PIE\02_test_images\03_pose\image_list.mat' 
and 'ACCV2012\02_data\02_Multi-PIE\02_test_images\03_pose\shape_list.mat' are 
stored in 'ACCV2012\02_data\01_Multi-PIE\02_test_images\03_pose\'.

---------------------------------------------------------------------------
General Fitting:    
        
For trying to fit our model to your own images use the script:

- 'Fit_POICA_AOM_InTheWild'

For this script to work, your images should be stored in 'ACCV2012\02_data\03_InTheWild\'.

---------------------------------------------------------------------------
Control Parameters:

- 'verbose'

If activated, text information about the fitting procedure is displayed on 
the matlab console.
 
- 'display' 

If activated, the evolution of the fitting procedure is graphically displayed.

- 'save_image' 

If activated, an image displaying the final fitting result is saved. 
Requires the control parameter display to be activated.
 
- 'video'

If activated, a video showing the evolution of the fitting procedure is 
created and saved. Requires the control parameter display to be activated.
 
###########################################################################
MODELS

- The XM2VTS Active Oriented Model has been trained using images from subject 079 
to subject 371.

- The Multi-PIE Active Oriented Models have been trained using images of subjects: 

002, 003, 006, 008, 011, 017, 019, 029, 035, 036, 038, 042, 044, 046, 047, 
049, 050, 053, 054, 055, 057, 064, 068, 070, 071, 079, 083, 105, 111, 118, 
124, 137, 138, 139, 143, 145, 149, 156, 157, 161, 169, 181, 184, 185, 186, 
190, 191, 198, 199, 202, 209, 220, 227 and 240.