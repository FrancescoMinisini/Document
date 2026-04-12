$out_dir = 'out';
$pdf_mode = 1;
$bibtex_use = 1;
# $bibtex_use = 2;

$pdflatex = 'pdflatex -shell-escape %O %S';

# Copy the PDF to the root directory after each successful build
$success_cmd = 'copy /Y out\\Tesi.pdf Tesi.pdf';
