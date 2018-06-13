#!/bin/bash
# Script para backup de Database Firebird #
#Criado por: Th14go
#GitHub - https://github.com/Th14go/script-bck-Firebird
#VARIAVEIS
DATA=`date +%Y-%m-%d-%H.%M`

SYNC_LOG=/var/log/sca/bckFirebird.log # local onde o arquivo de log sera armazenado

#Gera backup
echo "******************************" > $SYNC_LOG
echo "Inicio do Backup do Banco Firebird" >> $SYNC_LOG
date >> $SYNC_LOG
#echo "******************************" >> $SYNC_LOG
/opt/firebird/bin/./gbak -user SYSDBA -pass masterkey -v -b /home/administrador/DATABASES/BASE/dados.fdb /home/administrador/DATABASES/BKP-FDB/bckfdb-$DATA.gbak
echo "******************************" >> $SYNC_LOG
echo "Fim do Backup do Banco Firebird" >> $SYNC_LOG
date >> $SYNC_LOG
echo "******************************" >> $SYNC_LOG

#Compacta Backup do banco
echo "******************************" >> $SYNC_LOG
echo "Inicio da compactacao do Backup" >> $SYNC_LOG
date >> $SYNC_LOG
#echo "******************************" >> $SYNC_LOG
cd /home/administrador/DATABASES/BKP-FDB/ 
tar -cvzf bcksca-$DATA.zip  bcksca-$DATA.gbak
echo "******************************" >> $SYNC_LOG
echo "Fim da compactacao da Pasta Dados" >> $SYNC_LOG
#date >> $SYNC_LOG
echo "******************************" >> $SYNC_LOG

#Limpa temporarios de backup

rm -rvf /home/administrador/DATABASES/BKP-FDB/*.gbak

#Sincroniza com a pasta do servidor com a pasta de backup remoto com o host NTI
rsync -Cravp /home/administrador/DATABASES/BKP-SCA/ /mnt/backup/DATABASES/FIREBIRD/
rsync -Cravp /var/log/fdb /mnt/backup/LOG/


#apaga arquivos com mais de 10 dias Local
echo "**********INICIO REMOÇÃO LOCAL****************">>$SYNC_LOG
date >> $SYNC_LOG
find /home/administrador/DATABASES/BKP-FDB -mtime +10 -exec rm -rf {} \; >>$SYNC_LOG
date >> $SYNC_LOG
echo "**********INICIO REMOÇÃO LOCAL*****************">> $SYNC_LOG


#ApagandoBckAntigosRemoto
echo "***********INICIO REMOÇÃO REMOTA***************">>$SYNC_LOG
date >> $SYNC_LOG
find /mnt/backup/DATABASES/ -mtime +10 -exec rm -rf {} \; >>$SYNC_LOG
date >> $SYNC_LOG
echo "**********FIM REMOÇÃO REMOTA*******************">>$SYNC_LOG
