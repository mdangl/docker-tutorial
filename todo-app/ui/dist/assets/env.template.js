(function(window) {
    window["env"] = window["env"] || {};
  
    // Environment variables
    window["env"]["todoApiUrl"] = "${TODO_API_URL}" || "http://localhost:9080/api/v1";
  })(this);