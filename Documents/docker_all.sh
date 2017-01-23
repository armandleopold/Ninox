#!/bin/bash

##################################################
##################################################
#			      ARMAND LEOPOLD			 	 #
#			COMPTE RENDU COURS DOCKER 			 #
#			   Le 13 Décembre 2016				 #
##################################################
##################################################

# juste pour être sur que docker est installé
sudo apt-get update
sudo apt-get install -y docker.io

# ************** RAPPORT D'EXERCICES DOCKER **************

# On lance la commande :
	docker run debian
# pour lancer le téléchargement de debian si nécéssaire.

# Après avoir lancé la commande :
	docker run debian echo "Hello world!"
# On remarque que la console affiche un message "Hello world !"

# //////////////////////////////////////////////

# Après avoir lancé la commande :
	docker run debian ping google.fr
# rien ne se passe , on affiche les messages après avoir arrèté la commande en faisant : CTRL+C

# On lance en mode affichage un conteneur docker
	docker run -t debian ping google.fr

# On lance en mode interactif un conteneur docker
	docker run -i -t debian

# Afin d'installer VIM dans notre container root@98a6a2acd4f8
	apt-get update
	apt-get install -y vim

# Après avoir quitté et relancé un conteneur avec 
	docker run -i -t debian
# On remarque que vim n'est toujours pas installé

# //////////////////////////////////////////////

# On relance un docker debian
	docker run -i -t debian
# On installe vim
	apt-get update
	apt-get install -y vim
# On commit l'image 
	docker commit fd729ec626f9 debian_vi
# On lance un conteneur avec cette nouvelle image :
	docker run -it debian_vi
# On constate que vi est installé dans le nouveau conteneur

#//////////////////////////////////////////////

# Ecriture d'un bash qui supprime tous les conteneurs :

	#!bin/bash
	docker stop $(docker ps -a -q)
	docker kill $(docker ps -a -q)
	docker rm $(docker ps -a -q)

# //////////////////////////////////////////////

# On lance un docker debian
	docker run -it debian
	apt-get update
# On installe Open-SSH
	apt-get install -y openssh-server
# On lance le service SSHD
	/usr/sbin/sshd
# On obtient le message suivant : 
Missing privilege separation directory: /var/run/sshd
# On créer le dir
	mkdir /var/run/sshd
# On relance :
	/usr/sbin/sshd
# On ajoute un utilisateur :
	useradd -r -m ninox -p password
# On commit l'image :
	docker commit 6ac4a460a4ac debian_sshd

# On lance un docker_sshd en mode détaché avec le port 2222 associé au port 22 du conteneur, on lance le service ssh au démarrage :
	docker run -p 2222:22 debian_sshd  /usr/sbin/sshd -D

# On essaye de se connecter en ssh au conteneur :
	ssh ninox@0.0.0.0 -p 2222
# On nous demande le mot de passe de l'utilisateur, on le rentre, ça marche.

# //////////////////////////////////////////////

# On lance un docker debian
	docker run -it debian
	apt-get update
# On install wget :
	apt-get install -y wget vim
# On télécharge un jdk oracle 
	wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz
# On créer le dossier jdk
	mkdir /opt/jdk
# On extract l'archive dans le dossier jdk
	tar xf jdk-8u112-linux-x64.tar.gz -C /opt/jdk
# On ajoute java en variable d'environnement :
	export PATH=/opt/jdk/jdk1.8.0_112/bin:$PATH
	export JAVA_HOME=/opt/jdk/jdk1.8.0_112/bin/java:$PATH
# On exit et on commit le conteneur : 
	docker commit b73ddf38d069 debian_java


# On lance un conteneur debian_java :
	docker run -it debian_java
# ON créer un fichier hello world .java
	touch HelloWorld.java
# On edite le fichier :
	vim HelloWorld.java

# On insert (i) le texte suivant : 

public class HelloWorld {

    public static void main(String[] args) {
        // Prints "Hello, World" to the terminal window.
        System.out.println("Hello, World");
    }

}

(escape)

# On enregistre :
	:wq
# On lance la compilation du fichier :
	javac HelloWorld.java
# On run la classe : 
	java HelloWorld
# ça affiche bien :
	"Hello, World"

# //////////////////////////////////////////////

# On lance un docker debian
	docker run -it debian
	apt-get update
# On installe apache2 et vim
	apt-get install -y apache2 vim
# On va dans le dossier racine du serveur apache :
	cd /var/www/htlm
# On créer un fichier index.html: 
	touch index.html
# On l'édite :
	vim index.html

<!doctype html>

<html lang="en">
<head>
  <meta charset="utf-8">

  <title>The HTML5 Herald</title>
  <meta name="description" content="The HTML5 Herald">
  <meta name="author" content="SitePoint">

  <link rel="stylesheet" href="css/styles.css?v=1.0">

  <!--[if lt IE 9]>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.js"></script>
  <![endif]-->
</head>

<body>
  <p> Hello world ! </p>
  <script src="js/scripts.js"></script>
</body>
</html>

# On exit et on commit l'image en debian_apache :	
	docker commit e2aaf6127abd debian_apache
# On relance un docker debian_apache en ouvrant les ports : 
	docker run -it -p 2223:80 debian_apache
# On lance manuellement le service apache2
	service apache2 start
# On lance son navigateur avec l'adresse suivante :
	http://0.0.0.0:2223
# On obtiens bien une page avec ecrit hello world !

# On relance une image docker avec le nom serveur web :
	docker run -it --name serveur_web debian_apache
# On se connecte au serveur : 
	docker exec -it serveur_web /bin/bash
# On modifie le fichier et on voit bien une modification sur la page

# //////////////////////////////////////////////

	mkdir debian_vi
	cd debian_vi
	touch dockerfile
	vim dockerfile

# dockerfile : 

		FROM debian
		MAINTAINER toto <toto@toto.to>
		RUN apt-get update
		RUN apt-get -y install vim

# On build l'image :
	cd ..

	docker build -t debian_vi debian_vi/

# //////////////////////////////////////////////
	
	mkdir debian_java
	cd debian_java
# On télécharge l'archive jdk : 	
	wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz
	touch dockerfile
	vim dockerfile
	
# dockerfile : 

		FROM debian_vi
		MAINTAINER toto <toto@toto.to>
		WORKDIR .
		RUN mkdir /opt/jdk
		ADD jdk-8u111-linux-x64.tar.gz /opt/jdk
# On ajoute les variables d'environnement dans le dockerfile :
		ENV PATH /opt/jdk/jdk1.8.0_111/bin:$PATH
		ENV JAVA_HOME /opt/jdk/jdk1.8.0_111/bin/java

# On build l'image : 
	cd ..

	docker build -t debian_java debian_java/

# On run : 
	docker run -it debian_java

# Oo créer un fichier hello world .java
	touch HelloWorld.java
# On edite le fichier :
	vim HelloWorld.java

# On insert (i) le texte suivant : 

public class HelloWorld {

    public static void main(String[] args) {
        // Prints "Hello, World" to the terminal window.
        System.out.println("Hello, World");
    }

}

(escape)

# On enregistre :
	:wq
# On lance la compilation du fichier :
	javac HelloWorld.java
# On run la classe : 
	java HelloWorld
# ça affiche bien :
	"Hello, World"

# //////////////////////////////////////////////

	mkdir debian_nginx
	cd debian_nginx
	touch dockerfile
	vim dockerfile

# dockerfile : 

		FROM debian_vi
		MAINTAINER toto <toto@toto.to>
		WORKDIR .
		EXPOSE 80
		RUN apt-get update
		RUN apt-get install -y wget nginx
		CMD [ "service", "nginx", "start" ]

# On build l'image : 
	cd ..

	docker build -t debian_nginx debian_nginx/

# On run : 
	docker run -dit debian_nginx
# On accède bien à la page par défaut

	docker inspect hopeful_keller
# L'ip du conteneur nginx est 127.17.0.2
# Nous n'accèdons pas à la page par défaut

# le dossier racine du serveur web est : 
	/etc/nginx/sites-enabled/

# On relance en mode détaché en montant les volumes : 
	docker run -v /home/erandal/www/:/etc/nginx/sites-enabled/ -dit debian_nginx

# Nginx ne veut pas se lancer .... bizarre

# //////////////////////////////////////////////

	mkdir debian_lemp
	mkdir debian_lemp/www
	cd debian_lemp
	touch dockerfile
	vim dockerfile

# dockerfile : 

		FROM debian
		MAINTAINER toto <toto@toto.to>
		WORKDIR .
		RUN apt-get update
		RUN apt-get install -y nginx php5-fpm supervisor
		EXPOSE 80
		EXPOSE 9001
		CMD [ "service", "supervisor", "start" ]

# On build l'image : 
	cd ..

	docker build -t debian_lemp debian_lemp/

## Après manipulation  et installation manuelle de mariadb dans l'image docker

	cd debian_lemp/www
	touch supervisord.conf
	vim supervisord.conf

# supervisor.conf file : 

		[inet_http_server]
		port=9001

		[supervisord]
		logfile=/tmp/supervisord.log
		logfile_maxbytes=50MB
		logfile_backups=10
		loglevel=info
		pidfile=/tmp/supervisord.pid
		nodaemon=false
		minfds=1024
		minprocs=200

		[rpcinterface:supervisor]
		supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

		[supervisorctl]
		serverurl=unix:///tmp/supervisor.sock

		[program:nginx]
		command=/usr/sbin/nginx -g "daemon off"
		priority=990
		username=toto
		stdout_logfile=/tmp/%(program_name)s.stdout
		stderr_logfile=/tmp/%(program_name)s.stderr

		[program:php5-fpm]
		command=/usr/sbin/php5-fpm --nodaemonize
		priority=999
		username=toto
		stdout_logfile=/tmp/%(program_name)s.stdout
		stderr_logfile=/tmp/%(program_name)s.stderr

		[program:mariadb]
		command=/usr/sbin/mysqld_safe
		priority=999
		username=toto
		stdout_logfile=/tmp/%(program_name)s.stdout
		stderr_logfile=/tmp/%(program_name)s.stderr

# //////////////////////////////////////////////


# //////////////////////////////////////////// #
#           INSTALLATION DE NODE JS 		   #
# //////////////////////////////////////////// #

	mkdir nodejs
	cd nodejs
	touch dockerfile
	vim dockerfile

# Dockerfile : 

		FROM node:argon
		# Create app directory
		RUN mkdir -p /usr/src/app
		WORKDIR /usr/src/app
		# Install app dependencies
		COPY package.json /usr/src/app/
		RUN npm install
		# Bundle app source
		COPY . /usr/src/app
		EXPOSE 8080
		CMD [ "npm", "start" ]

# On build l'image : 
	cd ..
	docker build -t nodejs nodejs/

	docker run -p 49160:8080 -d nodejs