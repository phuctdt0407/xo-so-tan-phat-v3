(function () {
    app.service('baseService', ['$http',
        function ($http) {

            this.baseUrl = '/api';
            //this.uploadFileUrl = this.baseUrl + '/upload/uploadfile';

            //this.toFriendly = function (input) {
            //    return input.replace(/\+/g, "").replace(/\=/g, "").replace(/\//g, "").replace(/\-/g, "");
            //};

            //this.getTokenKeyName = function () {
            //    return this.toFriendly($base64.encode('enest_token'));
            //};

            //this.getCurrentToken = function () {
            //    var accessToken = getStorage(localStorageService, this.getTokenKeyName());
            //    return accessToken && accessToken !== null ? accessToken : null;
            //};

            //this.setCurrentToken = function (accessToken, tokenExpiryInSeconds) {
            //    if (accessToken && accessToken !== null && accessToken.length > 0) {
            //        setStorage(localStorageService, this.getTokenKeyName(), accessToken, tokenExpiryInSeconds);
            //    } else {
            //        localStorageService.clearAll(/(\w+)s_s(\w+)/);
            //    }
            //    return true;
            //};

            //this.getData = function (url, params) {
            //    return $http.get(url, { params: params, headers: this.getHeaders() }).then(function (result) {
            //        return result.data;
            //    });
            //};

            this.getData = function (url, params) {
                if (this.getHeaders() != null) {
                    return $http.get(url, { params: params, headers: this.getHeaders() }).then(function (result) {
                        return result.data.Data ? result.data.Data : result.data;
                    });
                } else {
                    return $http.get(url, { params: params}).then(function (result) {
                        return result.data.Data ? result.data.Data : result.data;
                    });
                }
            };

            //this.postData = function (url, params) {
            //    return $http.post(url, params, { headers: this.getHeaders() }).then(function (result) {
            //        return result.data;
            //    });
            //};

            this.postData = function (url, params) {
                if (this.getHeaders() != null) {
                    return $http.post(url, params, { headers: this.getHeaders() }).then(function (result) {
                        return result.data.Data ? result.data.Data : result.data;
                    });
                } else {

                    return $http.post(url, params).then(function (result) {
                        return result.data.Data ? result.data.Data : result.data;
                    });
                }
            };

            this.uploadFile = function (url, file, params) {
                var data = new FormData();

                data.append("Excel", file);
                data.append("Name", file.name);

                if (params) {
                    data.append("params", params);
                }
                return $http.post(url, data, {
                    headers: { 'Content-Type': undefined },
                    transformRequest: angular.identity
                }).then(function (res) {
                    return res.data;
                }).catch(function (errorCallback) {
                    return errorCallback;
                })
            };


            this.getHeaders = function (isUndefined) {
                if (getCookie("AUTH_")) {
                    //Use Cookie
                    return {
                        'Authorization': 'Bearer ' + getCookie("AUTH_"),
                        'Content-Type': isUndefined ? undefined : 'application/json; charset=utf-8'
                    };
                } else {
                     //Use LocalStorage
                    if (getLocalStorage("bearer")) {
                        return {
                            'Authorization': 'Bearer ' + getLocalStorage("bearer"),
                            'Content-Type': isUndefined ? undefined : 'application/json; charset=utf-8'
                        };
                    }
                    return null;
                }

             /*   var sessionInfo = this.getCurrentToken();
                if (sessionInfo && sessionInfo !== null) {
                    return {
                        'Authorization': 'Bearer ' + getLocalStorage("bearer") ,
                        'Content-Type': isUndefined ? undefined : 'application/json; charset=utf-8'
                    };
                }
                else {
                    return {
                        'Content-Type': isUndefined ? undefined : 'application/json; charset=utf-8'
                    };
                }*/
            };

            //this.uploadFile = function (url, file, params) {
            //    var data = new FormData();
            //    data.append(file.name, file);

            //    if (params) {
            //        data.append("params", params);
            //    }

            //    return $http.post(url, data, {
            //        withCredentials: true,
            //        headers: this.getHeaders(true),
            //        transformRequest: angular.identity
            //    }).then(function (res) {
            //        return res.data;
            //    });
            //};

            //this.uploadFileToCDN = function (file, params) {
            //    var data = new FormData();
            //    data.append(file.name, file);

            //    if (params) {
            //        data.append("params", params);
            //    }

            //    return $http.post(this.uploadFileUrl, data, {
            //        withCredentials: true,
            //        headers: this.getHeaders(true),
            //        transformRequest: angular.identity
            //    }).then(function (res) {
            //        return res.data;
            //    });
            //};
        }]);

    //function serializeToKeys(obj) {
    //    var str = [], p;
    //    for (p in obj) {
    //        if (obj.hasOwnProperty(p)) {
    //            var v = obj[p];
    //            str.push((v !== null && typeof v === "object") ? serializeToKeys(v) : encodeURIComponent(v));
    //        }
    //    }
    //    return str.join("_");
    //}

    function removeStorage(localStorageService, name) {
        try {
            localStorageService.remove(name);
            localStorageService.remove(name + '_expiresIn');
        } catch (e) {
            return false;
        }
        return true;
    }

    function getStorage(localStorageService, key) {
        var now = Date.now();

        var expiresIn = localStorageService.get(key + '_expiresIn');
        if (expiresIn === undefined || expiresIn === null) { expiresIn = 0; }

        if (expiresIn < now) {
            removeStorage(localStorageService, key);
            return null;
        } else {
            try {
                var value = localStorageService.get(key);
                return value;
            } catch (e) {
                console.log('getStorage: Error reading key [' + key + '] from localStorageService: ' + JSON.stringify(e));
                return null;
            }
        }
    }

    function setStorage(localStorageService, key, value, expiresSec) {
        if (expiresSec === undefined || expiresSec === null) {
            expiresSec = (12 * 60 * 60);  // default: seconds for 1 day
        } else {
            expiresSec = Math.abs(expiresSec); //make sure it's positive
        }

        var now = Date.now();  //millisecs since epoch time, lets deal only with integer
        var schedule = now + expiresSec * 1000;
        try {
            localStorageService.set(key, value);
            localStorageService.set(key + '_expiresIn', schedule);
        } catch (e) {
            return false;
        }
        return true;
    }
})();

(function () {
    app.service('sessionService', ['$rootScope', function ($rootScope) {
        var userSession;
        var userRole = [];

        this.setUserRole = function (data) {
            userRole = data;
            $rootScope.$broadcast('event:role-change', { some: 'data' });
        };

        this.setSession = function (data) {
            userSession = data;
        };

        this.getSession = function () {
            return userSession;
        };

        this.getUserRole = function () {
            return userRole;
        };
    }]);
})();

(function () {
    app.service('notificationService', ['$rootScope', function ($rootScope) {
        var defaultDelay = 2500;
 
        this.error = function (msg) {
            let toast = swal.mixin({
                toast: true,
                position: 'center',
                showConfirmButton: false,
                timer: defaultDelay,
                padding: '2em',
                background: '#ffe3e3',
            });

            toast({
                type: 'error',
                title: msg,
                padding: '2em',
            })
        };

        this.success = function (msg, time = defaultDelay) {
            let toast = swal.mixin({
                toast: true,
                position: 'center',
                showConfirmButton: false,
                timer: time,
                padding: '2em',
                background: '#b3ffc8',
            });

            toast({
                type: 'success',
                title: msg,
                padding: '2em',
            })
        };

        this.warning = function (msg) {
            let toast = swal.mixin({
                toast: true,
                position: 'center',
                showConfirmButton: false,
                timer: defaultDelay,
                padding: '2em',
                background: '#ffe1b5',
            });

            toast({
                type: 'warning',
                title: msg,
                padding: '2em',
            })
        };
    }]);
})();