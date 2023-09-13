(function () {
    app.controller('User.holidaySchedule', ['$scope', '$rootScope', '$state', 'viewModel', 'notificationService', 'userService', '$uibModal',
        function ($scope, $rootScope, $state, viewModel, notificationService, userService, $uibModal) {
            var vm = angular.extend(this, viewModel);

            vm.init = function () {
                vm.listHoliday.forEach(function (item) {
                    item.start = moment(item.Date).format("YYYY-MM-DD");
                    item.end = moment(item.Date).add(1, 'days').format("YYYY-MM-DD");
                    item.title = item.DateName;
                    item.id = item.EventDateId;
                })
                console.log("vm.listHoliday", vm.listHoliday);
            }

            vm.init();
            //func 
            vm.submitSearch = function (date) {
                $state.go($state.current, { month: moment(date).format('YYYY-MM') }, { reload: false, notify: true });
            };
            //Calendar
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
                customButtons: {
                    thisMonthButton: {
                        text: 'Hiện tại',
                        click: function () {
                            if (vm.params.month != moment().format('YYYY-MM')) {
                                vm.submitSearch(moment());
                            }
                        }
                    }
                },

                headerToolbar: {
                    //left: 'prev,next today',
                    left: 'thisMonthButton',
                    center: 'title',
                    right: ''
                },
                locale: 'vi',
                initialDate: vm.params.month,
                dateClick: function (info) {
                    vm.openModal(info.dateStr)
                },
                buttonIcons: false,
                weekNumbers: false,
                navLinks: true,
                //editable: false,
                //eventStartEditable: false,
                //eventDurationEditable: false,
                dayMaxEvents: true,
                dayMaxEventRows: true,
                nowIndicator: true,
                now: moment().format('YYYY-MM-DD HH:mm:ss'),
                views: {
                    dayGridMonth: {
                        dayMaxEvents: 4,
                        dayMaxEventRows: 4
                    },
                    timeGridWeek: {
                        dayMaxEvents: 4,
                        dayMaxEventRows: 4
                    }
                },
                //eventDidMount: function (info) {
                //},

                events: vm.listHoliday,
                eventTimeFormat: {
                    hour: '2-digit',
                    minute: '2-digit',
                    meridiem: false,
                    hour12: false
                },
                eventClick: function (event) {
                    var extend = event.event['_def'].extendedProps;
                    var date = moment(extend.Date).format("YYYY-MM-DD");
                    var note = extend.DateName;
                    vm.openModal(date, note);

                    console.log("extend", extend);
                },
                progressiveEventRendering: true
            });
            $(document).ready(function () {
                setTimeout(function () {
                    calendar.render();
                    $('.fc-daygrid-event.fc-daygrid-block-event').addClass("custom-height");
                    $('.fc-event-title.fc-sticky').addClass("custom-text")
                }, 500)
            });
            //modal
            vm.openModal = function (date, note = '') {
                var check = moment(moment().format('YYYY-MM-DD')).diff(moment(date,'YYYY-MM-DD'))<=0
                if (check) {
                    var viewPath = baseAppPath + '/user/views/modal/';
                    var request = $uibModal.open({
                        templateUrl: viewPath + 'addHoliday.html' + versionTemplate,
                        controller: 'User.addHoliday as $vm',
                        backdrop: 'static',
                        size: 'lg',
                        resolve: {
                            viewModel: ['$q', '$uibModal', 'userService',
                                function ($q, $uibModal, userService) {
                                    var deferred = $q.defer();
                                    $q.all([
                                    ]).then(function (res) {
                                        var result = {
                                            Date: date,
                                            HolidayName: angular.copy(note),
                                            isCreate: note == ''
                                        };
                                        deferred.resolve(result);
                                    });
                                    return deferred.promise;
                                }]
                        }
                    });

                    request.opened.then(function (res) {
                        $(document).ready(function () {
                            $('.modal-footer').addClass('remove-modal-footer');

                            $(document).ready(function () {
                                $('.modal-body').addClass('modal-body-rm');
                            });
                        });
                    });

                    request.result.then(function (data) {

                    }, function (data) {
                        if (typeof (data) == 'object') {
                            $state.reload();
                        }
                    });
                } else {
                    notificationService.warning("Không thể cập nhật ở quá khứ!!!");
                }
            }
        }]);
})();