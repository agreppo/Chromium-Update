# !/bin/sh
# Créer par Alexis Greppo
# Site : http://www.zen-tech.info
 
 
function get_sys_version {
 
	# On récupère la version installée actuellement
 
	if [ -f "/Applications/Chromium.app/Contents/Info.plist" ];then
		SYS_VERSION=`defaults read /Applications/Chromium.app/Contents/Info SVNRevision`
	else
		SYS_VERSION=0
	fi
 
	echo "Version installee $SYS_VERSION"
 
}
 
function get_svn_version {
	# On récupère le numéro de la dernière révision disponible sur le SVN 
	SVN_REVISION=`curl -s http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/LAST_CHANGE`
	echo "Version SVN $SVN_REVISION"
}
 
function install_chromium {
 
	cd /tmp
 
	# Téléchargement de la nouvelle version
 
	curl -L -O "http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/$1/chrome-mac.zip"
 
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
 
}
 
# On récupère la version installee et la version en ligne
get_sys_version
get_svn_version
 
if [ $SYS_VERSION -lt $SVN_REVISION ];then
 
	ps aux | grep /Applications/Chromium.app/Contents/MacOS/Chromium | grep -v grep
	# 1 si pas de ligne trouvée
	# 0 si chromium lancé
	# echo $?
 
	if [ $? -eq 1 ];then
		install_chromium $SVN_REVISION
	else
		echo "Vous devez fermer Chromium avant de lancer la mise à jour"
	fi
 
else 
	echo "Pas de mise à jour disponible"
fi
