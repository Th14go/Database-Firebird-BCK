#!/bin/bash
# Script para backup da pasta Dados

#VARIAVEIS
DATA=`date +%Y-%m-%d-%H.%M`

SYNC_LOG=/var/log/sca/bcksca.log # local onde o arquivo de log sera armazenado

#Gera backup
echo "******************************" > $SYNC_LOG
echo "Inicio do Backup do Banco" >> $SYNC_LOG
date >> $SYNC_LOG
#echo "******************************" >> $SYNC_LOG
/opt/firebird/bin/./gbak -user SYSDBA -pass masterkey -v -b /home/administrador/DATABASES/SCA/dados/dados.fdb /home/administrador/DATABASES/SCA/BKP-SCA/bcksca-$DATA.gbak
echo "******************************" >> $SYNC_LOG
echo "Fim do Backup do Banco" >> $SYNC_LOG
date >> $SYNC_LOG
echo "******************************" >> $SYNC_LOG



#Compacta Backup do banco
echo "******************************" >> $SYNC_LOG
echo "Inicio da compactacao do Backup de Log" >> $SYNC_LOG
date >> $SYNC_LOG
#echo "******************************" >> $SYNC_LOG
cd /home/administrador/DATABASES/SCA/BKP-SCA/ 
tar -cvzf bcksca-$DATA.zip  bcksca-$DATA.gbak
echo "******************************" >> $SYNC_LOG
echo "Fim da compactacao da Pasta Dados" >> $SYNC_LOG
#date >> $SYNC_LOG
echo "******************************" >> $SYNC_LOG

#Limpa temporarios de backup

rm -rvf /home/administrador/DATABASES/SCA/BKP-SCA/*.gbak

#Sincroniza com a pasta do servidor com a pasta de backup remoto com o host NTI
rsync -Cravp /home/administrador/DATABASES/SCA/BKP-SCA/ /mnt/backup/DATABASES/SCA/
rsync -Cravp /var/log/sca /mnt/backup/LOG/
#chown -R th14golop35 /home/administrador/DATABASES/SCA/BKP-SCA/*
#chmod 777 /home/administrador/DATABASES/SCA/BKP-SCA/*

#apaga arquivos com mais de 10 dias
find /home/administrador/DATABASES/SCA/BKP-SCA -mtime +5 -exec rm -rf {} \;


#Envia Email
#echo "******************************" >> $SYNC_LOG
#echo "Arquivo compactado" >> $SYNC_LOG
#ls -lha /spdata/backup/bd/bkdados-$DATA* >> $SYNC_LOG
#echo "******************************" >> $SYNC_LOG

