window.setLocalStorage = function (name, value) {
    localStorage.setItem(name, value);
};

window.getLocalStorage = function (name) {
    return localStorage.getItem(name);
};

window.removeLocalStorage = function (name) {
    localStorage.removeItem(name);
};

window.clearLocalStorage = function () {
    localStorage.clear(name);
};

window.getCookie = function (name) {
    var v = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
    return v ? v[2] : null;
};

window.setCookieDay = function (name, value, days) {
    var d = new Date;
    d.setTime(d.getTime() + 24 * 60 * 60 * 1000 * days);
    document.cookie = name + "=" + value + ";path=/;expires=" + d.toGMTString();
};

window.setCookieHour = function (name, value, hours) {
    var d = new Date;
    d.setTime(d.getTime() + 60 * 60 * 1000 * hours);
    document.cookie = name + "=" + value + ";path=/;expires=" + d.toGMTString();
};

window.setCookieSecond = function (name, value, second) {
    var d = new Date;
    d.setTime(d.getTime() + 1000 * second);
    document.cookie = name + "=" + value + ";path=/;expires=" + d.toGMTString();
};

window.deleteCookie = function (name) { setCookieDay(name, '', -1); };

window.isMobile = function () {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
};

if (!String.prototype.toUnaccent) {
    String.prototype.toUnaccent = function () {
        var str = this;
        if (str) {
            str = str.toLowerCase();
            str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, 'a');
            str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, 'e');
            str = str.replace(/ì|í|ị|ỉ|ĩ/g, 'i');
            str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, 'o');
            str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, 'u');
            str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, 'y');
            str = str.replace(/đ/g, 'd');
            // str = str.replace(/\W+/g, ' ');
            // str = str.replace(/\s/g, '-');
        }
        return str;
    };
}