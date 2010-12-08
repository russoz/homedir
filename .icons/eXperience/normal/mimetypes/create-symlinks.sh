#! /bin/sh

#This scrips is sure still missing quite a lot of symlinks so feel free to add them and tell me about it :)

raster="png jpeg tiff bmp gif x-xcf x-xbitmap x-xpimap x-psd"
vector_apps1="vnd.corel-draw"
vector_apps2="illustrator"
vector_image="x-eps"
document_apps="msword"
applications="x-executable"
scripts=""
info="x-install x-news"
zip="x-arj x-bzip-compressed-tar x-bzip x-compressed-tar x-compress x-gzip x-stuffit zip"

rm -f $( find ./ -type l -name gnome-mime-image-\* )
rm -f $( find ./ -type l -name gnome-mime-application-\* )

for i in $raster; do
	ln -s gnome-mime-image.svg gnome-mime-image-${i}.svg
done

for i in $vector_apps1; do
	ln -s gnome-mime-image-svg+xml.svg gnome-mime-application-${i}.svg
done

for i in $vector_apps2; do
	ln -s gnome-mime-application-postscript.svg gnome-mime-application-${i}.svg
done

for i in $vector_image; do
	ln -s gnome-mime-application-postscript.svg gnome-mime-image-${i}.svg
done

for i in $document_apps; do
	ln -s gnome-mime-application-vnd.sun.xml.writer.svg gnome-mime-application-${i}.svg
done

for i in $applications; do
	ln -s gnome-mime-application.svg gnome-mime-application-${i}.svg
done

for i in $scripts; do
	ln -s gnome-mime-application-shellscript.svg gnome-mime-application-${i}.svg
done

for i in $info; do
	ln -s gnome-mime-text-x-readme.svg gnome-mime-text-${i}.svg
done

for i in $zip; do
	ln -s gnome-mime-application-x-tar.svg gnome-mime-application-${i}.svg
done
