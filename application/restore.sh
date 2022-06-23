#!/usr/bin/env sh

STATUS=0

echo "mysql-backup-restore-fs: restore: Started"

echo "mysql-backup-restore-fs: Restoring ${DB_NAME}"

start=$(date +%s)
cp ${BACKUP_DIR}/${DB_NAME}.sql.gz /tmp/${DB_NAME}.sql.gz || STATUS=$?
end=$(date +%s)

if [ $STATUS -ne 0 ]; then
    echo "mysql-backup-restore-fs: FATAL: Copy backup of ${DB_NAME} from ${BACKUP_DIR} returned non-zero status ($STATUS) in $(expr ${end} - ${start}) seconds."
    exit $STATUS
else
    echo "mysql-backup-restore-fs: Copy backup of ${DB_NAME} from ${BACKUP_DIR} completed in $(expr ${end} - ${start}) seconds."
fi

start=$(date +%s)
gunzip -f /tmp/${DB_NAME}.sql.gz || STATUS=$?
end=$(date +%s)

if [ $STATUS -ne 0 ]; then
    echo "mysql-backup-restore-fs: FATAL: Decompressing backup of ${DB_NAME} returned non-zero status ($STATUS) in $(expr ${end} - ${start}) seconds."
    exit $STATUS
else
    echo "mysql-backup-restore-fs: Decompressing backup of ${DB_NAME} completed in $(expr ${end} - ${start}) seconds."
fi

start=$(date +%s)
mysql -h ${MYSQL_HOST} -u ${MYSQL_USER} -p"${MYSQL_PASSWORD}" ${DB_NAME} < /tmp/${DB_NAME}.sql || STATUS=$?
end=$(date +%s)

if [ $STATUS -ne 0 ]; then
    echo "mysql-backup-restore-fs: FATAL: Restore of ${DB_NAME} returned non-zero status ($STATUS) in $(expr ${end} - ${start}) seconds."
    exit $STATUS
else
    echo "mysql-backup-restore-fs: Restore of ${DB_NAME} completed in $(expr ${end} - ${start}) seconds."
fi

echo "mysql-backup-restore-fs: restore: Completed"
exit $STATUS
