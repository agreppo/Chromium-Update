# !/bin/sh
# Créer par Alexis Greppo
# Site : http://www.zen-tech.info

# On vérifie si Chromium est en cours d'exécution
ps aux | grep /Applications/Chromium.app/Contents/MacOS/Chromium | grep -v grep

# 1 si pas de ligne trouvée
# 0 si chromium lancé	

if [ $? -eq 1 ];then
	# On récupère le numéro de la dernière révision disponible sur le SVN 
	SVN_REVISION=`curl -s https://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/LAST_CHANGE`
	echo "Version SVN $SVN_REVISION"

	cd /tmp
 
	# Téléchargement de la nouvelle version
	curl -L -O "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/$SVN_REVISION/chrome-mac.zip"
 
	if [ $? -eq 0 ];then
		unzip -q ./chrome-mac.zip
	fi
 
	echo "Installation de l'application"
 
	if [ -f "/Applications/Chromium.app/Contents/Info.plist" ];then
		mv /Applications/Chromium.app /Applications/Chromium_old.app
	fi
 
	cp -R ./chrome-mac/Chromium.app /Applications/
 
	if [ $? -eq 0 ];then
		if [ -f "/Applications/Chromium_old.app/Contents/Info.plist" ];then
			rm -r /Applications/Chromium_old.app
		fi
	else
		mv /Applications/Chromium_old.app /Applications/Chromium.app
	fi
 
	echo "Suppression des fichiers temporaires"
	rm -r ./chrome-mac
	rm chrome-mac.zip
else
	echo "Vous devez fermer Chromium avant de lancer la mise à jour"
fi