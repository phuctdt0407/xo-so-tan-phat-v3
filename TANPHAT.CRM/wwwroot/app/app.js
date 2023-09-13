var app = angular.module('KTHubApp', ['ngRoute', 'ui.router', 'ui.bootstrap', 'ui.select', 'ngSanitize', 'angularjs-dropdown-multiselect', 'firebase', 'firebase.storage', 'ui.mask', 'dndLists']).info({ version: '1.0.0', name: 'KTHubApp' });

app.run(['$rootScope', '$transitions', 'notificationService', '$window', '$sce', 'sessionService', 'authService', '$state', '$uibModalStack', '$uibModal', 'userService',
    function ($rootScope, $transitions, notificationService, $window, $sce, sessionService, authService, $state, $uibModalStack, $uibModal, userService) {


        $rootScope.Hello = 'Angular running - ';
        $rootScope.inputText = false
        $rootScope.keyNumbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
        $rootScope.App = 'Module: ' + app.info().name;
        var version = 'Version: ' + app.info().version;
        var config = {
            apiKey: 'AIzaSyDHVn4jU8QJtXd9tWvfAAiGtpy8zn-YvUU',
            authDomain: 'theenestweb.firebaseapp.com',
            databaseURL: 'https://theenestweb.firebaseio.com',
            projectId: 'theenestweb',
            storageBucket: 'theenestweb.appspot.com',
        };
        firebase.initializeApp(config);

        $rootScope.reg = /^\d+$/;
        $rootScope.inputNumber = function (keyEvent) {
            if (keyEvent.which < 48 || keyEvent.which > 57) {
                keyEvent.preventDefault();
            }
        }
        $rootScope.pageTitleSuffix = 'TẤN PHÁT ';
        $rootScope.defaultPageSize = 200;
        $rootScope.TodayDOW = moment().format('ddd');
        $rootScope.today = moment().format('DD/MM/YYYY');
        $rootScope.todayFormat = moment().format('YYYY-MM-DD');

        $rootScope.LS_ExpiredHour_ListTime = 5;
        $rootScope.LS_ListTime_Name = 'LS_LIST_TIME';
        $rootScope.CKIE_ListTime_ExpiredName = 'CKIE_LIST_TIME_EX';

        $rootScope.DDMMYYYY_Pattern = /^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/\d{4}$/;

        $rootScope.phonePattern = /^(([+]?840)|0|([+]?84))(3|5|7|8|9){1}([0-9]{8})$/;

        $rootScope.passPattern = /^(?!.*\s)(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{6,}$/;

        $rootScope.usernamePattern = /^(?!.*\s)(?=.*[a-zA-Z]).{6,}$/;

        $rootScope.emailPattern =/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

        $rootScope.phoneFormat = function(phoneNumberString) {
            var cleaned = ('' + phoneNumberString).replace(/\D/g, '');
            var match = cleaned.match(/^([+]?)(\d{1}|\d{2}|\d{3})(\d{2})(\d{3})(\d{4})$/);
            if (match) {
                return '0' + match[3] + ' ' + match[4] + ' ' + match[5];
            }
            return phoneNumberString;
        }
        $rootScope.printElement = function (e) {
            var ifr = document.createElement('iframe');
            ifr.style = 'height: 0px; width: 0px; position: absolute'
            document.body.appendChild(ifr);
            $(e).clone().appendTo(ifr.contentDocument.body);
            ifr.contentWindow.print();
            ifr.parentElement.removeChild(ifr);
        }

        $rootScope.nonAccentVietnamese = function (str) {
           // str = str.toLowerCase();
            str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
            str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
            str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
            str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
            str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
            str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
            str = str.replace(/đ/g, "d");
            str = str.replace(/\u0300|\u0301|\u0303|\u0309|\u0323/g, ""); // Huyền sắc hỏi ngã nặng 
            str = str.replace(/\u02C6|\u0306|\u031B/g, ""); // Â, Ê, Ă, Ơ, Ư
            return str;
        }

        $rootScope.objToParam = function (obj) {
            var str = '';
            for (var key in obj) {
                if (str != "") {
                    str += "&";
                }
                str += key + "=" + obj[key];
            }
            return str;
        }

        $rootScope.rmDupValue = function(data, key) {
            return [...new Map(data.map(x => [key(x), x])).values()]
        }

        $rootScope.checkExpired = function (item) {//true: Expired
            return item > new Date() / 1000 - 500
        }

        $rootScope.formatHHmmss = function (secs) {
            var sec_num = parseInt(secs, 10); // don't forget the second param
            var hours = Math.floor(sec_num / 3600);
            var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
            var seconds = sec_num - (hours * 3600) - (minutes * 60);

            if (hours < 10) { hours = "0" + hours; }
            if (minutes < 10) { minutes = "0" + minutes; }
            if (seconds < 10) { seconds = "0" + seconds; }
            return hours + ':' + minutes + ':' + seconds;
        }

        $rootScope.copyClipboard = function (eleId) {
            var $temp = $("<input>");
            $("body").append($temp);
            $temp.val($("#" + eleId).val().trim()).select();
            if ($("#" + eleId).val().trim() && $("#" + eleId).val().trim() !== '') {
                document.execCommand("copy");
                notificationService.success('Copy to clipbard', 1000);
            }
            $temp.remove();
        }

        $rootScope.goToPage = function (page, param = {}, type = 0) {
            if (type == 0) {
                if (param == {}) {
                    $state.go(page);
                }
                else {
                    $state.go(page, param);
                }
            } else {
                var url = $state.href(page, param);
                window.open(url, '_blank');
            }

        }
        $rootScope.toHTML = function (text) {
            return $sce.trustAsHtml(text);
        }

        $rootScope.checkPermission = function (root) {

            var rs = sessionService.getUserRole().filter(ele => ele.root == root);

            if (rs && rs.length > 0) {
                return true;
            } else {
                return false;
            }
        }

        $rootScope.ddmOptionForPickUnit = {
            enableSearch: true,
            scrollable: true,
            clearSearchOnClose: true,
            buttonClasses: '',
            displayProp: 'UnitName',
            enableCheckAll: false,
            checkBoxes: true,
            showCheckAll: false,
            showUncheckAll: true,
            smartButtonMaxItems: 3,
            idProperty: 'UnitId'
        };

        $rootScope.ddmOptionForPickLesson = {
            enableSearch: true,
            scrollable: true,
            clearSearchOnClose: true,
            buttonClasses: '',
            displayProp: 'Lesson',
            enableCheckAll: false,
            checkBoxes: true,
            showCheckAll: false,
            showUncheckAll: true,
            smartButtonMaxItems: 3,
            idProperty: 'LessonId'
        };

        $rootScope.checkHeader = function () {
            if (getCookie("AUTH_")) {
                return true;
            } else if (getLocalStorage("bearer")) {
                return true;
            }
            return false;
        }

        var lostCon = function () {
            var viewPath = baseAppPath + '/components/';
            var modalInstance = $uibModal.open({
                templateUrl: viewPath + 'lostconnection.html' + versionTemplate,
                controller: ['$rootScope', '$state', '$uibModalInstance', function ($rootScope, $state, $uibModalInstance) {
                    $rootScope.close = function () {
                        $uibModalInstance.close()
                    }
                }],
                backdrop: 'static',
                size: 'md'
            });
        }

        $rootScope.GrpBy = function (xs, key) {
            return xs.reduce(function (rv, x) {
                (rv[x[key]] = rv[x[key]] || []).push(x);
                return rv;
            }, {});
        };

        $rootScope.numToCurrency = function (model,name,newValue = "0", oldValue = "0") {
            if(newValue ==null){
                newValue="0"
            }
            try {
                var temp = newValue.replace(/[^0-9]/g, '');
                temp = parseInt(temp)? parseInt(temp):0;
                temp = temp.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
                model[name] = temp;
                console.log("temp",temp)
            } catch (err) {
                console.log(err);
            }
        }

        $window.addEventListener("offline", function () {
            lostCon()
        }, false);

        $window.addEventListener("online", function () {
            $uibModalStack.dismissAll();
        }, false);

        $transitions.onBefore({}, function (trans) {
            
        });

        $transitions.onStart({}, function (trans) {
            $uibModalStack.dismissAll();
            $rootScope.showLoading = true;
            var toState = trans.$to();
            var toStateName = toState.name;

            if ($rootScope.checkHeader()) {
                if (toStateName === 'root.home') {
                    authService.getSession().then(function (res) {
                        //$rootScope.showLoading = true;
                        if (res && res.UserRoleId > 0) {
                            authService.getFirstPageShow({ userRoleId: res.UserRoleId }).then(function (res2) {
                                if (res2) {
                                   
                                    if (res2.ControllerName == 'home') {
                                        $state.go('root.home');
                                    } else {
                                        var urlState = 'root.' + res2.ControllerName.toLowerCase() + '.' + res2.ActionName.charAt(0).toLowerCase() + res2.ActionName.slice(1);
                                        $state.go(urlState);
                                    }

                                
                                }
                            });
                        }
                        //else {
                        //    if ($rootScope.checkHeader()) {
                        //        var i = 0;
                        //        var interval_obj = setInterval(function () {
                        //            i++;
                        //            authService.getSession().then(function (res1) {
                        //                if (res1 && res1.UserRoleId > 0) {
                        //                    clearInterval(interval_obj);
                        //                    $state.go('root.home');
                        //                }
                        //            })

                        //            if (i == 5) {
                        //                clearInterval(interval_obj);
                        //                $state.go('auth.login');
                        //            }
                        //        }, 800)
                        //    } else {
                        //        $state.go('auth.login');
                        //    }

                        //}
                    });
                }
            }
            else {
                $state.go('auth.login');
            }
            
        });

        $transitions.onSuccess({}, function (trans) {
            var root = trans.$to().name;

            if (root != 'auth.login') {
                if (root != 'root.error' && $rootScope.checkPermission(root) == false) {
                    $state.go('root.error', { code: 401 });

                }
            }

            setTimeout(function () {
                $rootScope.showLoading = false;
                $rootScope.$apply($rootScope.showLoading);
              //  $window.scrollTo(0, 0);
            }, 500);
        });

        $transitions.onError({}, function (trans) {

        });

        //SignalR - Process 
        $rootScope.connection = new signalR.HubConnectionBuilder()
            .withUrl("/chathub")
            .withAutomaticReconnect()
            .build();

        async function start() {
            try {
                await $rootScope.connection.start();
            } catch (err) {
                setTimeout(start, 5000);
            }
        };

        $rootScope.connection.onclose(start);

        start();
        //SignalR - Process

        //$rootScope.connection.on("ReceiveMessage", function (user, message) {
        //    if (user == 'updatePermission' && message && parseInt(message) > 0 && $rootScope.sessionInfo.UserTitles.indexOf(parseInt(message)) >= 0 && $state.current.name != 'root.user.rolePermission') {
        //        userService.getFirstPageShow({ userRoleId: $rootScope.sessionInfo.UserRoleId }).then(function (res2) {
        //            if (res2 && res2.ControllerName) {
        //                var urlState = 'root.' + res2.ControllerName.toLowerCase() + '.' + res2.ActionName.charAt(0).toLowerCase() + res2.ActionName.slice(1);
        //                $state.go(urlState);
        //            }
        //            else {
        //                $state.reload();
        //            }
        //        });
        //    }
        //});

        $rootScope.flagIsShow = true;
        initSize = function () {
            if ($(window).width() < 975) {
                //$rootScope.flagIsShow = false;
                //$rootScope.$apply($rootScope.flagIsShow);
            }
            else {
                //$rootScope.flagIsShow = true;
                //$rootScope.$apply($rootScope.flagIsShow);
            }
        }
        initSize();
        $(window).resize(function () {
            initSize();
        });

        $(document).keydown(function (e) {
            //if (e.keyCode == 123) { // Prevent F12 
            //    return false;
            //}
            if (e.ctrlKey && e.shiftKey && e.keyCode == 'C'.charCodeAt(0)) { // Prevent Ctrl+Shift+C 
                return false;
            }
            if (e.ctrlKey && e.shiftKey && e.keyCode == 'J'.charCodeAt(0)) { // Prevent Ctrl+Shift+J
                return false;
            }
            if (e.ctrlKey && e.shiftKey && e.keyCode == 'I'.charCodeAt(0)) { // Prevent Ctrl+Shift+I 
                return false;
            }
            if (e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)) { // Prevent Ctrl+U
                return false;
            }
            if (e.keyCode == 27) { // Prevent "esc"
                return false;
            }
        });
        //document.addEventListener('contextmenu', event => event.preventDefault()); // Prevent Right click

        // Keyboard
        $rootScope.eventInput = null


        $rootScope.removeNum = function () {
            $rootScope.eventInput.value = $rootScope.eventInput.value.slice(0, -1)
            $rootScope.eventInput.dispatchEvent(new Event('change'));
        }

        $rootScope.styleMain = "";

        $rootScope.showKeyBoard = function (ele, text) {
            $rootScope.eventInput = ele.srcElement
            $rootScope.inputText = text
            var a = document.getElementById("test");
            var h = window.innerHeight;
            var w = window.innerWidth;
            var p = h * 3 / 100;
            if (w > 670) a.classList.add("display")
        }

        $rootScope.closeKeyBoard = function () {
            $rootScope.eventInput = null
            var a = document.getElementById("test");
            $rootScope.styleMain = "";
            a.classList.remove("display")
        }

        $rootScope.changeNum = function (num) {
            if ($rootScope.inputText) {
                $rootScope.eventInput.value = ($rootScope.eventInput.value + num)
            } else {
                $rootScope.eventInput.value = ($rootScope.eventInput.value + num)*1
            }

            /*if ($rootScope.inputText) {
                $rootScope.eventInput.value = num.replace(/[^0-9]/g, '');
                $rootScope.eventInput.value = parseInt($rootScope.eventInput.value) ? parseInt($rootScope.eventInput.value) : 0;
                $rootScope.eventInput.value = $rootScope.eventInput.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
            } else {
                $rootScope.eventInput.value = ($rootScope.eventInput.value + num) * 1
            }

            try {
                var temp = newValue.replace(/[^0-9]/g, '');
                temp = parseInt(temp) ? parseInt(temp) : 0;
                temp = temp.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
                model[name] = temp;
                console.log("temp", temp)
            } catch (err) {
                console.log(err);
            }*/

            $rootScope.eventInput.dispatchEvent(new Event('change'));
        }

        $rootScope.stopClick = function (ele) {
            if (ele) ele.stopPropagation()
        }
        //PRINT BILL
        $rootScope.createBillNumber = function (billId) {
            var billNumber = billId.toString()
            var length = billNumber.length
            for (var i = 0; i < 8 - length; i++) {
                billNumber = '0' + billNumber
            }
            return billNumber;
        }

        $rootScope.printBill = function (saveBill, wholesaleData) {
            $rootScope.modifyBill(saveBill, wholesaleData);
            $rootScope.printElement($('#print'))
        }

         var ToCurrency = function (num) {
            return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
        }

        
        $rootScope.ToInt = function (text) {
            if (typeof (text) == 'string') {
                return parseInt(text.replace(/,/g, ''));
            }
            return text;
        };

        $rootScope.ToCurrency = function (text) {
            if (typeof (text) == 'string') {
                return text.replace(/\B(?=(\d{3})+(?!\d))/g, ',')
            }
            return text;
        };

        $rootScope.modifyBill = function (model, wholesaleData) {
            console.log("model: ", model)
            $("#BillAddress").text(model.FullAddress);
            $("#SalePoint").text(model.SalePoint);
            $("#DatePrint").text(model.DatePrint);
            $("#ShiftName").text(model.ShiftName);
            $("#PrintTime").text(model.PrintTime);
            $("#BillNumber").text(model.BillNumber);
            $("#DateTime").text(model.DateTime);
            $("#ActionName").text(model.ActionName);
            $("#CustomerName").text(model.CustomerName);
            $("#Sum").text(ToCurrency(model.Sum));
            $("#CustomerGive").text(ToCurrency(model.CustomerGive));
            $("#TotalDebt").text(ToCurrency(model.TotalDebt));
            $("#TotalQuatity").text(ToCurrency(model.TotalQuatity));
            $("#PromotionCode").text(model.PromotionCode);
            $("#ChannelName").text(model.ChannelName);
            $(".rm").remove()

            model.ListInfo.forEach(function (item, index) {
                $("#Detail_Bill").append(' <tr class="rm">'
                    + ' <td class= "description" id="LotteryName_' + index + '"> </td >'
                    + ' <td class="quantity t-right" id="Quantity_' + index + '"></td>'
                    + ' <td class="price t-right" id="Price_' + index + '"></td>'
                    + ' </tr >');

                $("#LotteryName_" + index).text(item.LotteryName + item.FourLastNumber);
                $("#Quantity_" + index).text(ToCurrency(item.Quantity));
                $("#Price_" + index).text(ToCurrency(item.Price));
            })
            var ele = $("#PromotionCode").text(model.PromotionCode)
            console.log("check promotion code bill",  ($("#PromotionCode").text(model.PromotionCode)[0].innerText))
            
            if( $("#PromotionCode").text(model.PromotionCode)[0].innerText == ''){
                console.log("check bill")
                $("#promotion")[0].style.display = 'none'
            }else{
                console.log("check billll")
                $("#promotion")[0].style.display = 'block'
            }
            if (wholesaleData == 2) {
                $("#History_Debt").append(
                    '<div class= "bill-total-quantity rm"> Nợ cũ: <span style="float: right;" id="OldDebt"></span></div >'
                    + '<div class="bill-total-quantity rm">Nợ mới: <span style="float: right;" id="NewDebt"></span></div>');

                $("#OldDebt").text(ToCurrency(model.OldDebt));
                $("#NewDebt").text(ToCurrency(model.NewDebt));
                
               
            }
        }

    }
]);