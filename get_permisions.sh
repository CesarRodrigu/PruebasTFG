#!/bin/bash

#!/bin/bash

# Cargar variables del .env
export $(sed -e 's/\r$//' -e '/^#/d' -e '/^$/d' .env | xargs)

# Archivo original
FILE="./sql/data.sql"

# Archivo temporal
TMPFILE=$(mktemp)

# Escribir el bloque al principio en el archivo temporal
cat <<EOF > "$TMPFILE"
CREATE USER IF NOT EXISTS '${MYSQLDB_USER}'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQLDB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Añadir después el contenido original
cat "$FILE" >> "$TMPFILE"

# Sobrescribir el archivo original con el temporal
mv "$TMPFILE" "$FILE"
