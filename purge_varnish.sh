#!/bin/bash
# Script for purge varnish cache, usage : bash ./purge_varnish.sh prod ALL

preprod="10.0.0.1"
prod="10.0.0.2 10.0.0.3"
user="purger"

echo "$(date "+%Y-%m-%d %H:%M") $@" >> /var/log/clear_cache

if [ ! -z $1 ] ; then
        case "$1" in
                -h|--help) echo "Usage ./clear_cache.sh ENV [HOST|ALL|URI]"; echo "For example HOST : exemple.com"; echo "For example URI : /accueil"; exit 1 ;;
                preprod) VARNISH_HOST=$preprod ;;
                prod) VARNISH_HOST=$prod  ;;
                *) echo "Merci de choisir entre les environnements suivants : preprod prod"; echo "Usage ./clear_cache.sh ENV [HOST|ALL|URI] argument"; exit 1 ;;
        esac ;
else
        echo "Usage ./clear_cache.sh ENV [HOST|ALL|URI] argument"; echo "For example HOST : exemple.com" ; echo "For example URI : /accueil"; exit 1 ;
fi

if [ -z $2 ] ; then
        echo "Usage ./clear_cache.sh ENV [HOST|ALL|URI] argument"; echo "For example HOST : exemple.com" ; echo "For example URI : /accueil"; exit 1;
fi

if [ $1 == "prod" ]; then
        echo "Etes-vous sur de vouloir purger le cache de la production (${1}) ? y/n"
        read REPLY
        if [ ! $REPLY == 'y' ]; then echo "Abandon"; exit 1; fi
fi

if [ $2 == "ALL" ] ; then
        for h in $VARNISH_HOST; do
                echo "purge sur $h..."
                ssh $user@$h "echo \"ban req.url ~ /*\" | varnishadm -S /etc/varnish/secret -T 127.0.0.1:6082"
        done
        echo "Cache cleared"
else
        if [ $2 == "HOST" ] ; then
                if [ ! -z $3 ] ; then
                        for h in $VARNISH_HOST; do
                                echo "purge sur $h..."
                                ssh $user@$h "echo \"ban req.http.host ~ $3\" | varnishadm -S /etc/varnish/secret -T 127.0.0.1:6082"
                        done
                        echo "$3 cleared"
                else
                        echo "Usage ./clear_cache.sh ENV HOST argument" ; echo "For example HOST : exemple.com"; exit 1 ;
                fi
        else
                if [ $2 == "URI" ] ; then
                        if [ ! -z $3 ] ; then
                                for h in $VARNISH_HOST; do
                                        echo "purge sur $h..."
                                        ssh $user@$h "echo \"ban req.url ~ $3\" | varnishadm -S /etc/varnish/secret -T 127.0.0.1:6082"
                                done
                                echo "$3 cleared"
                        else
                                echo "Usage ./clear_cache.sh ENV URI argument"; echo "For example URI : /accueil" ; exit 1 ;
                        fi
                else
                        echo "Usage ./clear_cache.sh ENV [HOST|ALL|URI] argument"; echo "For example HOST : exemple.com" ; echo "For example URI : /accueil"; exit 1 ;
                fi
        fi
fi

