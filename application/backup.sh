#!/usr/bin/env sh

STATUS=0

echo "mysql-backup-restore-fs: backup: Started"

echo "mysql-backup-restore-fs: Backing up ${DB_NAME}"

start=$(date +%s)
mysqldump -h ${MYSQL_HOST} -u ${MYSQL_USER} -p"${MYSQL_PASSWORD}" ${MYSQL_DUMP_ARGS} ${DB_NAME} > /tmp/${DB_NAME}.sql || STATUS=$?
end=$(date +%s)

if [ $STATUS -ne 0 ]; then
    echo "mysql-backup-restore-fs: FATAL: Backup of ${DB_NAME} returned non-zero status ($STATUS) in $(expr ${end} - ${start}) seconds."
    exit $STATUS
else
    echo "mysql-backup-restore-fs: Backup of ${DB_NAME} completed in $(expr ${end} - ${start}) seconds, ($(stat -c %s /tmp/${DB_NAME}.sql) bytes)."
fi

start=$(date +%s)
gzip -f /tmp/${DB_NAME}.sql || STATUS=$?
end=$(date +%s)
if [ $STATUS -ne 0 ]; then
    echo "mysql-backup-restore-fs: FATAL: Compressing backup of ${DB_NAME} returned non-zero status ($STATUS) in $(expr ${end} - ${start}) seconds."
    exit $STATUS
else
    echo "mysql-backup-restore-fs: Compressing backup of ${DB_NAME} completed in $(expr ${end} - ${start}) seconds."
fi

start=$(date +%s)
mv /tmp/${DB_NAME}.sql.gz ${BACKUP_DIR} || STATUS=$?
end=$(date +%s)
if [ $STATUS -ne 0 ]; then
    echo "mysql-backup-restore-fs: FATAL: Copy backup to ${BACKUP_DIR} of ${DB_NAME} returned non-zero status ($STATUS) in $(expr ${end} - ${start}) seconds."
    exit $STATUS
else
    echo "mysql-backup-restore-fs: Copy backup to ${BACKUP_DIR} of ${DB_NAME} completed in $(expr ${end} - ${start}) seconds."
fi

echo "mysql-backup-restore-fs: backup: Completed"
exit $STATUS
