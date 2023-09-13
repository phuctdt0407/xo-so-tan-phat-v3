app.directive('title', ['$rootScope', '$timeout', '$transitions', '$anchorScroll',
    function ($rootScope, $timeout, $transitions, $anchorScroll) {
        return {
            link: function () {
                var listener = function (toState) {

                    $timeout(function () {
                        $rootScope.title = toState.title ? $rootScope.pageTitleSuffix + ' - ' + toState.title : $rootScope.pageTitleSuffix;
                        $rootScope.headerTitle = toState.title;
                        /*console.log(toState.title)*/
                    });
                };

                $transitions.onSuccess({}, function (trans) {
                    listener(trans.$to());
                    $anchorScroll('header-top');

                    $rootScope.bindJavascriptEvents();
                });
            }
        };
    }
]);

app.directive('textTruncate', function () {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            class: '@?',
            title: '@'
        },
        template: '<span class="text-truncate {{class}}">{{title}}</span>',
        link: function (scope, element, attrs) {
        }
    };
});

app.directive('textTruncateNew', function () {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            class: '@?',
            title: '@',
            text: '@'
        },
        template: '<span class="text-truncate-new {{class}}">{{title}}<hr class="hr-dashboard-tag">{{text}}</span>',
        link: function (scope, element, attrs) {
        }
    };
});

app.directive('bread', [ '$state', function ($state) {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            isExpanded: '=?',
            temp: '@',
            title: '@',
            parent1: '@?',
            parent2: '@?',
            param1: '@?',
            param2: "@?",
            urlParent1: '@?',
            urlParent2: '@?',
        },
        templateUrl: baseAppPath + '/components/breadcrumbs.html' + versionTemplate,
        link: function (scope, element, attrs) {
            scope.temp = false;
            scope.toggleMenu = function () {
                //LEFT MENU
                if ($('#container').hasClass("sidebar-closed")) {
                    $("#container").removeClass("sidebar-closed");
                    scope.temp = false
                }
                else {
                    $("#container").addClass("sidebar-closed");
                    scope.temp = true
                }
                //HEADER
                if ($('#header').hasClass("sidebar-closed")) {
                    $("#header").removeClass("sidebar-closed");

                }
                else {
                    $("#header").addClass("sidebar-closed");

                }
                //SUB HEADER 
                if ($('#subHeader').hasClass("sidebar-closed")) {
                    $("#subHeader").removeClass("sidebar-closed");
                }
                else {
                    $("#subHeader").addClass("sidebar-closed");
                }
            };

            scope.ChangePage = function (root, param) {
                if (param) {
                    $state.go(root, JSON.parse(param))
                } else {
                    $state.go(root)
                }
            }

            scope.$watch('isExpanded', function (newVal, oldVal) {
                    if (newVal) {
                        $("#container").addClass("sidebar-closed");
                        $("#header").addClass("sidebar-closed");
                        $("#subHeader").addClass("sidebar-closed");
                        scope.temp = true;
                    }
                    else {
                        $("#container").removeClass("sidebar-closed");
                        $("#header").removeClass("sidebar-closed");
                        $("#subHeader").removeClass("sidebar-closed");
                        scope.temp = false;
                    }
                });
        }
    };
}]);


app.directive('loading', function () {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            class: '@?',
            title: '@'
        },
        template: '<div class="loader dual-loader mx-auto"></div>',
        link: function (scope, element, attrs) {
        }
    };
});

app.directive('pagination', ['$rootScope', '$state', function ($rootScope, $state) {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: baseAppPath + '/components/pagination.html' + versionTemplate,
        scope: {
            params: '=',
            totalRow: '=',
            noReload: '=?',
        },
        link: function (scope, elem, attrs) {
            scope.IsShowCount = true;
            scope.stateName = $state.current.name;
            scope.CountShowPage = 5;
            scope.pageNumber = scope.params.p ? scope.params.p : 1;
            scope.noReload = scope.noReload ? scope.noReload : false;
            scope.rowPerPage = 0;
            scope.startNum = 0;
            scope.endNum = 0;
            scope.startIndex = 1;
            scope.endIndex = 1;

            scope.rowPerPage = scope.params.ps ? scope.params.ps.toString() : $rootScope.defaultPageSize.toString();
            scope.totalPage = Math.ceil(scope.totalRow / scope.rowPerPage);
            scope.listDisplayCount = [
                { value: 5, name: '05' },
                { value: 10, name: '10' },
                { value: 20, name: '20' },
                { value: 50, name: '50' },
                { value: 100, name: '100' }
            ];
            scope.startIndex = ((scope.pageNumber - 1) * scope.rowPerPage) + 1;
            scope.endIndex = Number(scope.startIndex) + Number(scope.rowPerPage) - 1;
            scope.endIndex = scope.endIndex >= scope.totalRow ? scope.totalRow : scope.endIndex;

            var FuncWatchTotalRow = function () {
                scope.totalPage = Math.ceil(scope.totalRow / scope.rowPerPage);
          
                if (scope.pageNumber <= scope.CountShowPage / 2 && scope.totalPage <= scope.CountShowPage) {
                    scope.startNum = 1;
                    scope.endNum = scope.CountShowPage;
                }
                else if (scope.pageNumber <= scope.CountShowPage / 2 && scope.totalPage > scope.CountShowPage) {
                    scope.startNum = 1;
                    scope.endNum = scope.CountShowPage - 1;
                }
                else if (scope.pageNumber > (scope.totalPage - scope.CountShowPage / 2) && scope.totalPage > scope.CountShowPage) {
                    scope.endNum = scope.totalPage;
                    scope.startNum = scope.endNum - (scope.CountShowPage / 2) - 1;
                }
                else {
                    scope.startNum = scope.pageNumber - scope.CountShowPage / 2 + 1;
                    scope.endNum = scope.startNum + scope.CountShowPage / 2;
                }

                if (scope.startNum < 1) {
                    scope.startNum = 1;
                }
                if (scope.endNum > scope.totalPage) {
                    scope.endNum = scope.totalPage;
                }
            }


            if (scope.pageNumber <= scope.CountShowPage / 2 && scope.totalPage <= scope.CountShowPage) {
                scope.startNum = 1;
                scope.endNum = scope.CountShowPage;
            }
            else if (scope.pageNumber <= scope.CountShowPage / 2 && scope.totalPage > scope.CountShowPage) {
                scope.startNum = 1;
                scope.endNum = scope.CountShowPage - 1;
            }
            else if (scope.pageNumber > (scope.totalPage - scope.CountShowPage / 2) && scope.totalPage > scope.CountShowPage) {
                scope.endNum = scope.totalPage;
                scope.startNum = scope.endNum - (scope.CountShowPage / 2) - 1;
            }
            else {
                scope.startNum = scope.pageNumber - scope.CountShowPage / 2 + 1;
                scope.endNum = scope.startNum + scope.CountShowPage / 2;
            }

            if (scope.startNum < 1) {
                scope.startNum = 1;
            }
            if (scope.endNum > scope.totalPage) {
                scope.endNum = scope.totalPage;
            }

            scope.getNumber = function (num) {
                return new Array(num);
            };

            scope.GoToPage = function (p, e) {
                e.preventDefault();
                if (p !== scope.pageNumber) {
                    if (scope.params.from) {
                        scope.params.from = moment(scope.params.from).format('YYYY-MM-DD');
                    }
                    if (scope.params.to) {
                        scope.params.to = moment(scope.params.to).format('YYYY-MM-DD');
                    }
                    if (scope.noReload == false) {
                        $state.go('.', angular.extend(scope.params, { p: p }));
                    }
                    else {
                        //scope.$apply(function () {
                        //    scope.params = angular.extend(scope.params, { p: p });
                        //})

                        scope.params = angular.extend(scope.params, { p: p });
                        FuncWatchTotalRow()
                    }
                   
                }
            };

            scope.PreviousPage = function () {
                if (scope.params.p > 1) {
                    if (scope.params.from) {
                        scope.params.from = moment(scope.params.from).format('YYYY-MM-DD');
                    }
                    if (scope.params.to) {
                        scope.params.to = moment(scope.params.to).format('YYYY-MM-DD');
                    }
                    if (scope.noReload == false) {
                        $state.go('.', angular.extend(scope.params, { p: Number(scope.pageNumber) - 1 }));
                    }
                    else {
                        //scope.$apply(function () {
                        //    scope.params = angular.extend(scope.params, { p: Number(scope.pageNumber) - 1 });
                        //})

                        scope.params = angular.extend(scope.params, { p: Number(scope.pageNumber) - 1 });
                        FuncWatchTotalRow()
                    }
                }
            };

            scope.NextPage = function (e) {
                e.preventDefault();
                if (scope.params.p < scope.totalPage) {
                    if (scope.params.from) {
                        scope.params.from = moment(scope.params.from).format('YYYY-MM-DD');
                    }
                    if (scope.params.to) {
                        scope.params.to = moment(scope.params.to).format('YYYY-MM-DD');
                    }
                    if (scope.noReload == false) {
                        $state.go('.', angular.extend(scope.params, { p: Number(scope.pageNumber) + 1 }));
                    }
                    else {
                        //scope.$apply(function () {
                        //    scope.params = angular.extend(scope.params, { p: Number(scope.pageNumber) + 1 });
                        //})

                        scope.params = angular.extend(scope.params, { p: Number(scope.pageNumber) + 1 });
                        FuncWatchTotalRow()
                    }
                }
            };

            scope.ChangePageSize = function () {
                if (scope.params.from) {
                    scope.params.from = moment(scope.params.from).format('YYYY-MM-DD');
                }
                if (scope.params.to) {
                    scope.params.to = moment(scope.params.to).format('YYYY-MM-DD');
                }
                if (scope.noReload == false) {
                    $state.go('.', angular.extend(scope.params, { p: 1, ps: Number(scope.rowPerPage) }));
                }
                else {
                    //scope.$apply(function () {
                    //    scope.params = angular.extend(scope.params, { p: 1, ps: Number(scope.rowPerPage) });
                    //})
                    scope.params = angular.extend(scope.params, { p: 1, ps: Number(scope.rowPerPage) });
                    FuncWatchTotalRow();
                }
            };

           
            scope.$watch('totalRow', function (val) {
                if (val) {
                    FuncWatchTotalRow();
                }
            });

            scope.$watch('params.p', function (val) {
                if (val) {
                    scope.pageNumber = val;
                    scope.startIndex = ((scope.pageNumber - 1) * scope.rowPerPage) + 1;
                    scope.endIndex = Number(scope.startIndex) + Number(scope.rowPerPage) - 1;
                    scope.endIndex = scope.endIndex >= scope.totalRow ? scope.totalRow : scope.endIndex;
                    if (scope.pageNumber <= scope.CountShowPage / 2 && scope.totalPage <= scope.CountShowPage) {
                        scope.startNum = 1;
                        scope.endNum = scope.CountShowPage;
                    }
                    else if (scope.pageNumber <= scope.CountShowPage / 2 && scope.totalPage > scope.CountShowPage) {
                        scope.startNum = 1;
                        scope.endNum = scope.CountShowPage - 1;
                    }
                    else if (scope.pageNumber > (scope.totalPage - scope.CountShowPage / 2) && scope.totalPage > scope.CountShowPage) {
                        scope.endNum = scope.totalPage;
                        scope.startNum = scope.endNum - (scope.CountShowPage / 2) - 1;
                    }
                    else {
                        scope.startNum = scope.pageNumber - scope.CountShowPage / 2 + 1;
                        scope.endNum = scope.startNum + scope.CountShowPage / 2;
                    }

                    if (scope.startNum < 1) {
                        scope.startNum = 1;
                    }
                    if (scope.endNum > scope.totalPage) {
                        scope.endNum = scope.totalPage;
                    }
 
                }
            });
        }
    }
}]);

app.directive('daterangepicker', function () {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: baseAppPath + '/components/daterangepicker.html' + versionTemplate,
        scope: {
            startDate: '=',
            endDate: '=',
            minDate: '=?'
        },
        link: function (scope) {
            scope.startDate = scope.startDate ? scope.startDate : moment().startOf('month');
            scope.endDate = scope.endDate ? scope.endDate : moment().endOf('month');
            var start = scope.startDate;
            var end = scope.endDate;
            var useMinDate = scope.minDate ? true : false
            var mindate = scope.minDate ? scope.minDate : null
            try {
                if (moment(mindate) > moment(start)) {
                    start = mindate;
                }
            } catch (err) {}
            cb = function (start, end) {
                scope.startDate = start;
                scope.endDate = end;
                var e = $('#daterangepicker span').html(start.format('DD-MM-YYYY') + ' - ' + end.format('DD-MM-YYYY'));
                e[0].classList.add("text-black");
                
            }
            $('#daterangepicker').daterangepicker(useMinDate ? {
                    startDate: start,
                    endDate: end,
                    autoApply: true,
                    minDate: moment(mindate)
                } : {
                        startDate: start,
                        endDate: end,
                        autoApply: true,
                        ranges: {
                            'Today': [moment(), moment()],
                            'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                            'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                            'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                            'This Month': [moment().startOf('month'), moment().endOf('month')],
                            'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                        }
                    }  , cb);
            $(".daterangepicker, #daterangepicker").on("mouseenter", function () {
                $('#daterangepicker')[0].classList.add("border-blue");
            })
                .on("mouseleave", function () {
                    $('#daterangepicker')[0].classList.remove("border-blue");
                });
            cb(start, end);
        }
    }
})

app.directive('yearpicker', function () {
    return {
        restrict: 'E',
        require: 'ngModel',
        replace: true,
        templateUrl: baseAppPath + '/components/monthyearpicker.html' + versionTemplate,
        scope: {
            dateFormat: '@',
            dateMin: '=',
            dateMax: '=',
            placeholder: '@',
            outputFormat: '@',
            onSelect: '&',
            model: '=ngModel',
            ngClass: '=ngClass',
            myClass: '@',
            opens: '@',
            pickTime: '@',
            timeStep: '@',
            ngDisabled: '=',
            classId: '@'
        },
        link: function (scope, elem, attrs, ngModelCtrl) {
            
            scope.dateFormat = angular.isUndefined(scope.dateFormat) ? 'DD-MM-YYYY' : scope.dateFormat;
            scope.outputFormat = angular.isUndefined(scope.outputFormat) ? 'YYYY-MM-DD' : scope.outputFormat;
            scope.formatedModel = scope.model ? moment(scope.model).format(scope.dateFormat) : null;
            scope.opens = scope.opens ? scope.opens : 'bottom left';
            var dpEle = $(elem).find('input[type=text]:first');
            if (scope.pickTime && scope.timeStep) {
                if (scope.dateMin) {
                    var lessMinutes = parseInt(moment(scope.dateMin).format('mm'));
                    if (lessMinutes > (60 - scope.timeStep)) {
                        scope.dateMin = moment(scope.dateMin).add(60 - lessMinutes, 'minutes');
                    }
                }
            }
            var yearPicker = dpEle.datepicker({
                format: " yyyy",
                viewMode: "years",
                minViewMode: "years",
                autoClose: true,
                orientation: scope.opens
            });

            yearPicker.on('changeDate', function (e) {
                e.date = e.date == 'Invalid Date' ? moment() : e.date;
                var momentDate = e.date ? moment(e.date) : null;
                if (momentDate !== null) {
                    scope.$apply(function () {
                        scope.formatedModel = momentDate.format('YYYY');
                        scope.model = momentDate.format('YYYY');
                    });
                    if (scope.onSelect !== undefined && momentDate !== null)
                        scope.onSelect({ date: momentDate });
                }
            });

            yearPicker.data('datepicker').setValue(moment(scope.model));
        }
    };
});


app.directive('monthyearpicker', function () {
    return {
        restrict: 'E',
        require: 'ngModel',
        replace: true,
        templateUrl: baseAppPath + '/components/monthyearpicker.html' + versionTemplate,
        scope: {
            dateFormat: '@',
            dateMin: '=',
            dateMax: '=',
            placeholder: '@',
            outputFormat: '@',
            onSelect: '&',
            model: '=ngModel',
            ngClass: '=ngClass',
            myClass: '@',
            opens: '@',
            pickTime: '@',
            timeStep: '@',
            ngDisabled: '=',
            classId: '@'
        },
        link: function (scope, elem, attrs, ngModelCtrl) {
            scope.dateFormat = angular.isUndefined(scope.dateFormat) ? 'DD-MM-YYYY' : scope.dateFormat;
            scope.outputFormat = angular.isUndefined(scope.outputFormat) ? 'YYYY-MM-DD' : scope.outputFormat;
            scope.formatedModel = scope.model ? moment(scope.model).format(scope.dateFormat) : null;
            scope.opens = scope.opens ? scope.opens : 'bottom left';
            var dpEle = $(elem).find('input[type=text]:first');
            if (scope.pickTime && scope.timeStep) {
                if (scope.dateMin) {
                    var lessMinutes = parseInt(moment(scope.dateMin).format('mm'));
                    if (lessMinutes > (60 - scope.timeStep)) {
                        scope.dateMin = moment(scope.dateMin).add(60 - lessMinutes, 'minutes');
                    }
                }
            }
            var monthPicker = dpEle.datepicker({
                format: "mm/yyyy",
                viewMode: "months",
                minViewMode: "months",
                autoClose: true,
                orientation: scope.opens
            });
            monthPicker.on('changeDate', function (e) {
                e.date = e.date == 'Invalid Date' ? moment() : e.date;
                var momentDate = e.date ? moment(e.date) : null;
                if (momentDate !== null) {
                    scope.$apply(function () {
                        scope.formatedModel = momentDate.format('MM/YYYY');
                        scope.model = momentDate.format('YYYY-MM');
                    });
                    if (scope.onSelect !== undefined && momentDate !== null)
                        scope.onSelect({ date: momentDate });
                }
            });
            monthPicker.data('datepicker').setValue(moment(scope.model));
        }
    };
});


app.directive('datepicker', function () {
    return {
        restrict: 'E',
        require: 'ngModel',
        replace: true,
        templateUrl: baseAppPath + '/components/datepicker.html' + versionTemplate,
        scope: {
            dateFormat: '@',
            dateMin: '=',
            dateMax: '=',
            placeholder: '@',
            daysOfWeekDisabled: '=',
            outputFormat: '@',
            onSelect: '&',
            model: '=ngModel',
            ngClass: '=ngClass',
            myClass: '@',
            iconClass: '@',
            wrapperClass: '@',
            //pickTime: '@',
            ngDisabled: '=',
            myid: '@'
        },
        link: function (scope, elem, attrs, ngModelCtrl) {
            scope.dateFormat = angular.isUndefined(scope.dateFormat) ? 'DD-MM-YYYY' : scope.dateFormat;
            scope.outputFormat = angular.isUndefined(scope.outputFormat) ? 'YYYY-MM-DD' : scope.outputFormat;
            //scope.pickTime = angular.isUndefined(scope.pickTime) ? true : (scope.pickTime == 'true' ? true : false);
            var dpEle = $(elem).find('input[type=text]:first');
          
            var initDatepicker = function () {
                //destroy nếu đã có 
                if (dpEle.data('DateTimePicker') !== undefined) {
                    dpEle.data('DateTimePicker').destroy();
                    dpEle.unbind('changeDate');
                }

                //init option

                var options = {
                    format: (scope.dateFormat == 'dddd, DD-MM-YYYY') ? 'DD, dd-mm-yyyy' : (scope.dateFormat == 'ddd, DD-MM-YYYY')? 'D, dd-mm-yyyy' : 'dd-mm-yyyy',
                    startView: 'month',
                    minView: 'month',
                    autoclose: true,
                    //useCurrent: false,
                    //pickTime: angular.isUndefined(scope.pickTime) ? true : (scope.pickTime === 'true' ? true : false),

                    //daysOfWeekDisabled: angular.isUndefined(scope.daysOfWeekDisabled) ? [] : scope.daysOfWeekDisabled
                };

                if (scope.ngDisabled)
                    dpEle.attr('disabled', 'disabled');
                else
                    dpEle.removeAttr('disabled');
                dpEle.datetimepicker(options);

                if (scope.dateMin !== undefined) {
                    dpEle.datetimepicker('setStartDate', scope.dateMin);
                }

                if (scope.dateMax !== undefined) {
                    dpEle.datetimepicker('setEndDate', scope.dateMax);

                }

                dpEle.on('changeDate', function (e) {
                    var momentDate = e.date ? moment(e.date) : null;
                    var val = '';

                    if (momentDate !== null) {
                        switch (scope.outputFormat) {
                            case 'timestamp':
                                val = momentDate.valueOf();
                                break;
                            default:
                                val = momentDate.format(scope.outputFormat);
                                break;
                        }
                        ngModelCtrl.$setViewValue(val);
                        if (scope.onSelect !== undefined && momentDate !== null)
                            scope.onSelect({ date: momentDate, formatedDate: val, weekDay: momentDate.weekday() });
                    }
                });
            };

            scope.$watch('daysOfWeekDisabled', function (newVal, oldVal) {
                scope.daysOfWeekDisabled = newVal;
                initDatepicker();
            });

            scope.$watch('dateMin', function (newVal, oldVal) {
                if (newVal !== undefined && dpEle.data("DateTimePicker")) {
                    dpEle.data("DateTimePicker").minDate(moment(newVal));
                }
            });

            scope.$watch('dateMax', function (newVal, oldVal) {
                if (newVal !== undefined && dpEle.data("DateTimePicker")) {
                    dpEle.data("DateTimePicker").maxDate(moment(newVal));
                }
            });

            scope.$watch('model', function (newVal, oldVal) {
                if (newVal === null) { // set null value to UI
                    $('#datepicker' + scope.myid).val(null)
                } else {
                    $('#datepicker' + scope.myid).val(moment(newVal, ['DD-MM-YYYY', 'YYYY-MM-DD']).format(scope.dateFormat))
                }
                if (dpEle.data("DateTimePicker")) {
                    if (newVal === undefined) {
                        dpEle.data('DateTimePicker').date(null);
                    }
                    else {
                        dpEle.data('DateTimePicker').date(moment(newVal).format(scope.dateFormat));
                    }
                }
            });
            initDatepicker();
        }
    };
});

app.directive('datepickerNew', function () {
    return {
        restrict: 'E',
        require: 'ngModel',
        replace: true,
        templateUrl: baseAppPath + '/components/datepickerNew.html' + versionTemplate,
        scope: {
            dateFormat: '@',
            dateMin: '=',
            dateMax: '=',
            placeholder: '@',
            //daysOfWeekDisabled: '=',
            outputFormat: '@',
            onSelect: '&',
            model: '=ngModel',
            ngClass: '=ngClass',
            myClass: '@',
            //iconClass: '@',
            wrapperClass: '@',
            opens: '@',
            pickTime: '@',
            timeStep: '@',
            ngDisabled: '=',
            type: '@'
        },
        link: function (scope, elem, attrs, ngModelCtrl) {
            scope.dateFormat = angular.isUndefined(scope.dateFormat) ? 'DD-MM-YYYY' : scope.dateFormat;
            scope.outputFormat = angular.isUndefined(scope.outputFormat) ? 'YYYY-MM-DD' : scope.outputFormat;
            scope.formatedModel = scope.model ? moment(scope.model).format(scope.dateFormat) : null;

            var dpEle = $(elem).find('input[type=text]:first');
            if (scope.pickTime && scope.timeStep) {
                if (scope.dateMin) {
                    var lessMinutes = parseInt(moment(scope.dateMin).format('mm'));
                    if (lessMinutes > (60 - scope.timeStep)) {
                        scope.dateMin = moment(scope.dateMin).add(60 - lessMinutes, 'minutes');
                    }
                }
            }

            scope.type = scope.type ? scope.type : 0;
            var options = null;
            if (scope.type == 0) {
                options = {
                    //parentEl: getParentElement(),
                    //singleDatePicker: true,
                    timePicker: angular.isUndefined(scope.pickTime) ? false : scope.pickTime.toLowerCase() == "true" ? true : false,
                    timePickerIncrement: angular.isUndefined(scope.timeStep) ? 1 : parseInt(scope.timeStep),
                    autoUpdateInput: false,
                    autoApply: true,
                    showDropdowns: true,
                    startDate: scope.model ? moment(scope.model).format(scope.dateFormat) : moment(scope.dateMax ? scope.dateMax : new Date()).format(scope.dateFormat),
                    minDate: scope.dateMin ? scope.dateMin : undefined,
                    maxDate: scope.dateMax ? scope.dateMax : undefined,
                    opens: scope.opens ? scope.opens : 'left',
                    locale: {
                        format: scope.dateFormat
                    }
                };
            }
            else {
                options = {
                    parentEl: getParentElement(),
                    timePicker: true,
                    singleDatePicker: true,
                    timePicker24Hour: true,
                    timePickerIncrement: 10,
                    timePickerSeconds: false,
                    autoUpdateInput: false,
                    startDate: scope.model ? moment(scope.model).format(scope.dateFormat) : moment().format(scope.dateFormat),
                    locale: {
                        format: scope.dateFormat
                    }
                };
            }

            if (scope.type == 0) {
                dpEle.daterangepicker(options);
            }
            else {
                dpEle.daterangepicker(options).on('show.daterangepicker', function (ev, picker) {
                    picker.container.find(".calendar-table").hide();
                });
            }

            dpEle.on('apply.daterangepicker', function (ev, picker) {
                var start = picker.startDate;
                var momentDate = start ? start : null;
                var val = '';
                if (momentDate !== null) {
                    scope.$apply(function () {
                        scope.formatedModel = momentDate.format(scope.dateFormat);
                        scope.model = momentDate.format(scope.outputFormat);
                    });

                    if (scope.onSelect !== undefined && momentDate !== null) {
                        scope.$apply(function () {
                            scope.onSelect({ date: momentDate });
                        });
                    }
                }
            });

            scope.$watch('dateMin', function (newVal, oldVal) {
                if (newVal !== undefined) {
                    dpEle.data("daterangepicker").minDate = moment(newVal);
                }
            });

            scope.$watch('dateMax', function (newVal, oldVal) {
                if (newVal !== undefined) {
                    dpEle.data("daterangepicker").maxDate = moment(newVal);
                }
            });
        }
    };
});

app.directive('telephone', function () {
    return {
        restrict: 'A',
        scope: {
            data: '=',
            clickCallback: '&',
            selectedItem: '=',
            ngMode: '='
        },
        templateUrl: baseAppPath + '/components/phoneInput.html' + versionTemplate,
        link: function (scope, element, attrs) {
            scope.optValue = attrs.optValue;
            scope.optDescription = attrs.optDescription;
            scope.optFilter = attrs.optFilter;
        }
    };
});

app.directive("contenteditable", function () {
    return {
        restrict: "A",
        require: "ngModel",

        link: function (scope, element, attrs, ngModel) {
            // read is the main handler, invoked here by the blur event
            function read() {
                // Keep the newline value for substitutin
                // when cleaning the <br>
                var newLine = String.fromCharCode(10);
                // Firefox adds a <br> for each new line, we replace it back
                // to a regular '\n'

                var formattedValue = element.html().replace(/<br>/ig, newLine).replace(/\r/ig, '').replaceAll('&nbsp;', ' ').replaceAll('&amp;','');
                //var formattedValue = element.html()
                // update the model
                ngModel.$setViewValue(formattedValue);
                // Set the formated (cleaned) value back into
                // the element's html.
                element.text(formattedValue);
            }

            ngModel.$render = function () {
                element.html(ngModel.$viewValue || "");
            };

            element.bind("blur", function () {
                // update the model when
                // we loose focus
                scope.$apply(read);
            });
            element.bind("paste", function (e) {
                // This is a tricky one
                // when copying values while
                // editing, the value might be
                // copied with formatting, for example
                // <span style="line-height: 20px">copied text</span>
                // to overcome this, we replace
                // the default behavior and
                // insert only the plain text
                // that's in the clipboard
                e.preventDefault();
                document.execCommand('inserttext', false, e.clipboardData.getData('text/plain'));
            });
        }
    };
});

