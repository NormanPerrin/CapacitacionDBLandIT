FROM mongo:3.0

COPY facturas.json facturas.json

CMD mongoimport --host mongodb --db reach-engine -d finanzas -c facturas facturas.json