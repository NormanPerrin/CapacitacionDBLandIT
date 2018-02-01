ls -1 *.json | while read jsonfile; do
  collection=$(basename $jsonfile ".json");
  mongoimport --host mongodb --db reach-engine -d finanzas -c $collection $jsonfile;
done