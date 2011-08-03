# !/bin/sh
# Créé par Alexis Greppo
# Site : http://www.zen-tech.info


function get_sys_version {

	# On récupère la version installée actuellement
	SYS_VERSION=`defaults read /Applications/Chromium.app/Contents/Info SVNRevision`
	
	if [ $? -eq 1 ];then
		SYS_VERSION = 0
	fi
	
	echo $SYS_VERSION
}

function get_svn_version {
	# On récupère le numéro de la dernière révision disponible sur le SVN 
	SVN_REVISION=`curl -s http://build.chromium.org/f/chromium/snapshots/chromium-rel-mac/LATEST`
	echo $SVN_REVISION
}

function install_chromium {
	

	# Téléchargement de la nouvelle version
	cd /tmp
	curl -O "http://build.chromium.org/f/chromium/snapshots/chromium-rel-mac/$1/chrome-mac.zip"
	
	if [ $? -eq 0 ];then
		unzip -q ./chrome-mac.zip
	fi
	
	
	echo "Installation de l'application"
	# On renomme la version actuelle
	#Ajouter des tests en cas d'erreur
	mv /Applications/Chromium.app /Applications/Chromium_old.app
	
	
	
	cp -R ./chrome-mac/Chromium.app /Applications/
	
	echo "Suppression des fichiers temporaires"
	
	rm -r /Applications/Chromium_old.app
	
	rm -r ./chrome-mac
	rm chrome-mac.zip

}

SYS_VERSION = get_sys_version
SVN_REVISION = get_svn_version

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