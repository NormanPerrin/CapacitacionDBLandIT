var config = {
  _id: 'configRS',
  members: [{ _id: 0, host: 'localhost:27500' }]
};

rs.initiate(config);