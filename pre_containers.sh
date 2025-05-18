#!/bin/bash

SRC_DIR="docs/pdfs"

DEST_DIR="app/src/main/resources/static/pdfs"

mkdir -p "$DEST_DIR"

cp "$SRC_DIR/memoria.pdf" "$DEST_DIR/"
cp "$SRC_DIR/anexos.pdf" "$DEST_DIR/"
export $(sed -e 's/\r$//' -e '/^#/d' -e '/^$/d' .env | xargs)

FILE="./sql/data.sql"

TMPFILE=$(mktemp)

cat <<EOF > "$TMPFILE"
CREATE USER IF NOT EXISTS '${MYSQLDB_USER}'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQLDB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

cat "$FILE" >> "$TMPFILE"

mv "$TMPFILE" "$FILE"
