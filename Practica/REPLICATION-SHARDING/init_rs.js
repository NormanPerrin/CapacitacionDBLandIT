var config = {
  _id: 'rs2',
  members: [
    {_id: 0, host: 'localhost:27158'},
    {_id: 1, host: 'localhost:27159'},
    {_id: 2, host: 'localhost:27160'}
  ]
};

rs.initiate(config);