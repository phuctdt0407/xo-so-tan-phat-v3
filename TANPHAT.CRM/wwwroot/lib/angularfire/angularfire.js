!function (a) {
    "use strict";
    angular.module("firebase.utils", []), angular.module("firebase.config", []), angular.module("firebase.auth", ["firebase.utils"]), angular.module("firebase.database", ["firebase.utils"]), angular.module("firebase.storage", ["firebase.utils"]), angular.module("firebase", ["firebase.utils", "firebase.config", "firebase.auth", "firebase.database", "firebase.storage"]).value("Firebase", a.firebase).value("firebase", a.firebase)
}(window), function () {
    "use strict";
    var a;
    angular.module("firebase.auth").factory("$firebaseAuth", ["$q", "$firebaseUtils", function (b, c) {
        return function (d) {
            d = d || firebase.auth();
            var e = new a(b, c, d);
            return e.construct()
        }
    }]), a = function (a, b, c) {
        if (this._q = a, this._utils = b, "string" == typeof c) throw new Error("The $firebaseAuth service accepts a Firebase auth instance (or nothing) instead of a URL.");
        if ("undefined" != typeof c.ref) throw new Error("The $firebaseAuth service accepts a Firebase auth instance (or nothing) instead of a Database reference.");
        this._auth = c, this._initialAuthResolver = this._initAuthResolver()
    }, a.prototype = {
        construct: function () {
            return this._object = {
                $signInWithCustomToken: this.signInWithCustomToken.bind(this),
                $signInAnonymously: this.signInAnonymously.bind(this),
                $signInWithEmailAndPassword: this.signInWithEmailAndPassword.bind(this),
                $signInWithPopup: this.signInWithPopup.bind(this),
                $signInWithRedirect: this.signInWithRedirect.bind(this),
                $signInWithCredential: this.signInWithCredential.bind(this),
                $signOut: this.signOut.bind(this),
                $onAuthStateChanged: this.onAuthStateChanged.bind(this),
                $getAuth: this.getAuth.bind(this),
                $requireSignIn: this.requireSignIn.bind(this),
                $waitForSignIn: this.waitForSignIn.bind(this),
                $createUserWithEmailAndPassword: this.createUserWithEmailAndPassword.bind(this),
                $updatePassword: this.updatePassword.bind(this),
                $updateEmail: this.updateEmail.bind(this),
                $deleteUser: this.deleteUser.bind(this),
                $sendPasswordResetEmail: this.sendPasswordResetEmail.bind(this),
                _: this
            }, this._object
        }, signInWithCustomToken: function (a) {
            return this._q.when(this._auth.signInWithCustomToken(a))
        }, signInAnonymously: function () {
            return this._q.when(this._auth.signInAnonymously())
        }, signInWithEmailAndPassword: function (a, b) {
            return this._q.when(this._auth.signInWithEmailAndPassword(a, b))
        }, signInWithPopup: function (a) {
            return this._q.when(this._auth.signInWithPopup(this._getProvider(a)))
        }, signInWithRedirect: function (a) {
            return this._q.when(this._auth.signInWithRedirect(this._getProvider(a)))
        }, signInWithCredential: function (a) {
            return this._q.when(this._auth.signInWithCredential(a))
        }, signOut: function () {
            return null !== this.getAuth() ? this._q.when(this._auth.signOut()) : this._q.when()
        }, onAuthStateChanged: function (a, b) {
            var c = this._utils.debounce(a, b, 0), d = this._auth.onAuthStateChanged(c);
            return d
        }, getAuth: function () {
            return this._auth.currentUser
        }, _routerMethodOnAuthPromise: function (a, b) {
            var c = this;
            return this._initialAuthResolver.then(function () {
                var d = c.getAuth(), e = null;
                return e = a && null === d ? c._q.reject("AUTH_REQUIRED") : b && !d.emailVerified ? c._q.reject("EMAIL_VERIFICATION_REQUIRED") : c._q.when(d)
            })
        }, _getProvider: function (a) {
            var b;
            if ("string" == typeof a) {
                var c = a.slice(0, 1).toUpperCase() + a.slice(1);
                b = new firebase.auth[c + "AuthProvider"]
            } else b = a;
            return b
        }, _initAuthResolver: function () {
            var a = this._auth;
            return this._q(function (b) {
                function c() {
                    d(), b()
                }

                var d;
                d = a.onAuthStateChanged(c)
            })
        }, requireSignIn: function (a) {
            return this._routerMethodOnAuthPromise(!0, a)
        }, waitForSignIn: function () {
            return this._routerMethodOnAuthPromise(!1, !1)
        }, createUserWithEmailAndPassword: function (a, b) {
            return this._q.when(this._auth.createUserWithEmailAndPassword(a, b))
        }, updatePassword: function (a) {
            var b = this.getAuth();
            return b ? this._q.when(b.updatePassword(a)) : this._q.reject("Cannot update password since there is no logged in user.")
        }, updateEmail: function (a) {
            var b = this.getAuth();
            return b ? this._q.when(b.updateEmail(a)) : this._q.reject("Cannot update email since there is no logged in user.")
        }, deleteUser: function () {
            var a = this.getAuth();
            return a ? this._q.when(a.delete()) : this._q.reject("Cannot delete user since there is no logged in user.")
        }, sendPasswordResetEmail: function (a) {
            return this._q.when(this._auth.sendPasswordResetEmail(a))
        }
    }
}(), function () {
    "use strict";

    function a(a) {
        return a()
    }

    a.$inject = ["$firebaseAuth"], angular.module("firebase.auth").factory("$firebaseAuthService", a)
}(), function () {
    "use strict";
    angular.module("firebase.database").factory("$firebaseArray", ["$log", "$firebaseUtils", "$q", function (a, b, c) {
        function d(a) {
            if (!(this instanceof d)) return new d(a);
            var c = this;
            return this._observers = [], this.$list = [], this._ref = a, this._sync = new e(this), b.assertValidRef(a, "Must pass a valid Firebase reference to $firebaseArray (not a string or URL)"), this._indexCache = {}, b.getPublicMethods(c, function (a, b) {
                c.$list[b] = a.bind(c)
            }), this._sync.init(this.$list), this.$list.$resolved = !1, this.$loaded().finally(function () {
                c.$list.$resolved = !0
            }), this.$list
        }

        function e(d) {
            function e(a) {
                if (!r.isDestroyed) {
                    r.isDestroyed = !0;
                    var b = d.$ref();
                    b.off("child_added", j), b.off("child_moved", l), b.off("child_changed", k), b.off("child_removed", m), d = null, q(a || "destroyed")
                }
            }

            function f(b) {
                var c = d.$ref();
                c.on("child_added", j, p), c.on("child_moved", l, p), c.on("child_changed", k, p), c.on("child_removed", m, p), c.once("value", function (c) {
                    angular.isArray(c.val()) && a.warn("Storing data using array indices in Firebase can result in unexpected behavior. See https://firebase.google.com/docs/database/web/structure-data for more information."), q(null, b)
                }, q)
            }

            function g(a, b) {
                o || (o = !0, a ? i.reject(a) : i.resolve(b))
            }

            function h(a, b) {
                var d = c.when(a);
                d.then(function (a) {
                    a && b(a)
                }), o || n.push(d)
            }

            var i = c.defer(), j = function (a, b) {
                d && h(d.$$added(a, b), function (a) {
                    d.$$process("child_added", a, b)
                })
            }, k = function (a) {
                if (d) {
                    var b = d.$getRecord(a.key);
                    b && h(d.$$updated(a), function () {
                        d.$$process("child_changed", b)
                    })
                }
            }, l = function (a, b) {
                if (d) {
                    var c = d.$getRecord(a.key);
                    c && h(d.$$moved(a, b), function () {
                        d.$$process("child_moved", c, b)
                    })
                }
            }, m = function (a) {
                if (d) {
                    var b = d.$getRecord(a.key);
                    b && h(d.$$removed(a), function () {
                        d.$$process("child_removed", b)
                    })
                }
            }, n = [], o = !1, p = b.batch(function (a) {
                g(a), d && d.$$error(a)
            }), q = b.batch(g), r = {
                destroy: e, isDestroyed: !1, init: f, ready: function () {
                    return i.promise.then(function (a) {
                        return c.all(n).then(function () {
                            return a
                        })
                    })
                }
            };
            return r
        }

        return d.prototype = {
            $add: function (a) {
                this._assertNotDestroyed("$add");
                var d, e = this, f = c.defer(), g = this.$ref().ref.push();
                try {
                    d = b.toJSON(a)
                } catch (a) {
                    f.reject(a)
                }
                return "undefined" != typeof d && b.doSet(g, d).then(function () {
                    e.$$notify("child_added", g.key), f.resolve(g)
                }).catch(f.reject), f.promise
            }, $save: function (a) {
                this._assertNotDestroyed("$save");
                var d = this, e = d._resolveItem(a), f = d.$keyAt(e), g = c.defer();
                if (null !== f) {
                    var h, i = d.$ref().ref.child(f);
                    try {
                        h = b.toJSON(e)
                    } catch (a) {
                        g.reject(a)
                    }
                    "undefined" != typeof h && b.doSet(i, h).then(function () {
                        d.$$notify("child_changed", f), g.resolve(i)
                    }).catch(g.reject)
                } else g.reject("Invalid record; could not determine key for " + a);
                return g.promise
            }, $remove: function (a) {
                this._assertNotDestroyed("$remove");
                var d = this.$keyAt(a);
                if (null !== d) {
                    var e = this.$ref().ref.child(d);
                    return b.doRemove(e).then(function () {
                        return e
                    })
                }
                return c.reject("Invalid record; could not determine key for " + a)
            }, $keyAt: function (a) {
                var b = this._resolveItem(a);
                return this.$$getKey(b)
            }, $indexFor: function (a) {
                var b = this, c = b._indexCache;
                if (!c.hasOwnProperty(a) || b.$keyAt(c[a]) !== a) {
                    var d = b.$list.findIndex(function (c) {
                        return b.$$getKey(c) === a
                    });
                    d !== -1 && (c[a] = d)
                }
                return c.hasOwnProperty(a) ? c[a] : -1
            }, $loaded: function (a, b) {
                var c = this._sync.ready();
                return arguments.length && (c = c.then.call(c, a, b)), c
            }, $ref: function () {
                return this._ref
            }, $watch: function (a, b) {
                var c = this._observers;
                return c.push([a, b]), function () {
                    var d = c.findIndex(function (c) {
                        return c[0] === a && c[1] === b
                    });
                    d > -1 && c.splice(d, 1)
                }
            }, $destroy: function (a) {
                this._isDestroyed || (this._isDestroyed = !0, this._sync.destroy(a), this.$list.length = 0)
            }, $getRecord: function (a) {
                var b = this.$indexFor(a);
                return b > -1 ? this.$list[b] : null
            }, $$added: function (a) {
                var c = this.$indexFor(a.key);
                if (c === -1) {
                    var d = a.val();
                    return angular.isObject(d) || (d = {$value: d}), d.$id = a.key, d.$priority = a.getPriority(), b.applyDefaults(d, this.$$defaults), d
                }
                return !1
            }, $$removed: function (a) {
                return this.$indexFor(a.key) > -1
            }, $$updated: function (a) {
                var c = !1, d = this.$getRecord(a.key);
                return angular.isObject(d) && (c = b.updateRec(d, a), b.applyDefaults(d, this.$$defaults)), c
            }, $$moved: function (a) {
                var b = this.$getRecord(a.key);
                return !!angular.isObject(b) && (b.$priority = a.getPriority(), !0)
            }, $$error: function (b) {
                a.error(b), this.$destroy(b)
            }, $$getKey: function (a) {
                return angular.isObject(a) ? a.$id : null
            }, $$process: function (a, b, c) {
                var d, e = this.$$getKey(b), f = !1;
                switch (a) {
                    case"child_added":
                        d = this.$indexFor(e);
                        break;
                    case"child_moved":
                        d = this.$indexFor(e), this._spliceOut(e);
                        break;
                    case"child_removed":
                        f = null !== this._spliceOut(e);
                        break;
                    case"child_changed":
                        f = !0;
                        break;
                    default:
                        throw new Error("Invalid event type: " + a)
                }
                return angular.isDefined(d) && (f = this._addAfter(b, c) !== d), f && this.$$notify(a, e, c), f
            }, $$notify: function (a, b, c) {
                var d = {event: a, key: b};
                angular.isDefined(c) && (d.prevChild = c), angular.forEach(this._observers, function (a) {
                    a[0].call(a[1], d)
                })
            }, _addAfter: function (a, b) {
                var c;
                return null === b ? c = 0 : (c = this.$indexFor(b) + 1, 0 === c && (c = this.$list.length)), this.$list.splice(c, 0, a), this._indexCache[this.$$getKey(a)] = c, c
            }, _spliceOut: function (a) {
                var b = this.$indexFor(a);
                return b > -1 ? (delete this._indexCache[a], this.$list.splice(b, 1)[0]) : null
            }, _resolveItem: function (a) {
                var b = this.$list;
                if (angular.isNumber(a) && a >= 0 && b.length >= a) return b[a];
                if (angular.isObject(a)) {
                    var c = this.$$getKey(a), d = this.$getRecord(c);
                    return d === a ? d : null
                }
                return null
            }, _assertNotDestroyed: function (a) {
                if (this._isDestroyed) throw new Error("Cannot call " + a + " method on a destroyed $firebaseArray object")
            }
        }, d.$extend = function (a, c) {
            return 1 === arguments.length && angular.isObject(a) && (c = a, a = function (b) {
                return this instanceof a ? (d.apply(this, arguments), this.$list) : new a(b)
            }), b.inherit(a, d, c)
        }, d
    }]), angular.module("firebase").factory("$FirebaseArray", ["$log", "$firebaseArray", function (a, b) {
        return function () {
            return a.warn("$FirebaseArray has been renamed. Use $firebaseArray instead."), b.apply(null, arguments)
        }
    }])
}(), function () {
    "use strict";
    angular.module("firebase.database").factory("$firebaseObject", ["$parse", "$firebaseUtils", "$log", "$q", function (a, b, c, d) {
        function e(a) {
            if (!(this instanceof e)) return new e(a);
            var c = this;
            this.$$conf = {
                sync: new g(this, a),
                ref: a,
                binding: new f(this),
                listeners: []
            }, Object.defineProperty(this, "$$conf", {value: this.$$conf}), this.$id = a.ref.key, this.$priority = null, b.applyDefaults(this, this.$$defaults), this.$$conf.sync.init(), this.$resolved = !1, this.$loaded().finally(function () {
                c.$resolved = !0
            })
        }

        function f(a) {
            this.subs = [], this.scope = null, this.key = null, this.rec = a
        }

        function g(a, e) {
            function f(b) {
                n.isDestroyed || (n.isDestroyed = !0, e.off("value", k), a = null, m(b || "destroyed"))
            }

            function g() {
                e.on("value", k, l), e.once("value", function (a) {
                    angular.isArray(a.val()) && c.warn("Storing data using array indices in Firebase can result in unexpected behavior. See https://firebase.google.com/docs/database/web/structure-data for more information. Also note that you probably wanted $firebaseArray and not $firebaseObject."), m(null)
                }, m)
            }

            function h(b) {
                i || (i = !0, b ? j.reject(b) : j.resolve(a))
            }

            var i = !1, j = d.defer(), k = b.batch(function (b) {
                if (a) {
                    var c = a.$$updated(b);
                    c && a.$$notify()
                }
            }), l = b.batch(function (b) {
                h(b), a && a.$$error(b)
            }), m = b.batch(h), n = {
                isDestroyed: !1, destroy: f, init: g, ready: function () {
                    return j.promise
                }
            };
            return n
        }

        return e.prototype = {
            $save: function () {
                var a, c = this, e = c.$ref(), f = d.defer();
                try {
                    a = b.toJSON(c)
                } catch (a) {
                    f.reject(a)
                }
                return "undefined" != typeof a && b.doSet(e, a).then(function () {
                    c.$$notify(), f.resolve(c.$ref())
                }).catch(f.reject), f.promise
            }, $remove: function () {
                var a = this;
                return b.trimKeys(a, {}), a.$value = null, b.doRemove(a.$ref()).then(function () {
                    return a.$$notify(), a.$ref()
                })
            }, $loaded: function (a, b) {
                var c = this.$$conf.sync.ready();
                return arguments.length && (c = c.then.call(c, a, b)), c
            }, $ref: function () {
                return this.$$conf.ref
            }, $bindTo: function (a, b) {
                var c = this;
                return c.$loaded().then(function () {
                    return c.$$conf.binding.bindTo(a, b)
                })
            }, $watch: function (a, b) {
                var c = this.$$conf.listeners;
                return c.push([a, b]), function () {
                    var d = c.findIndex(function (c) {
                        return c[0] === a && c[1] === b
                    });
                    d > -1 && c.splice(d, 1)
                }
            }, $destroy: function (a) {
                var c = this;
                c.$isDestroyed || (c.$isDestroyed = !0, c.$$conf.sync.destroy(a), c.$$conf.binding.destroy(), b.each(c, function (a, b) {
                    delete c[b]
                }))
            }, $$updated: function (a) {
                var c = b.updateRec(this, a);
                return b.applyDefaults(this, this.$$defaults), c
            }, $$error: function (a) {
                c.error(a), this.$destroy(a)
            }, $$scopeUpdated: function (a) {
                var c = d.defer();
                return this.$ref().set(b.toJSON(a), b.makeNodeResolver(c)), c.promise
            }, $$notify: function () {
                var a = this, b = this.$$conf.listeners.slice();
                angular.forEach(b, function (b) {
                    b[0].call(b[1], {event: "value", key: a.$id})
                })
            }, forEach: function (a, c) {
                return b.each(this, a, c)
            }
        }, e.$extend = function (a, c) {
            return 1 === arguments.length && angular.isObject(a) && (c = a, a = function (b) {
                return this instanceof a ? void e.apply(this, arguments) : new a(b)
            }), b.inherit(a, e, c)
        }, f.prototype = {
            assertNotBound: function (a) {
                if (this.scope) {
                    var b = "Cannot bind to " + a + " because this instance is already bound to " + this.key + "; one binding per instance (call unbind method or create another FirebaseObject instance)";
                    return c.error(b), d.reject(b)
                }
            }, bindTo: function (c, d) {
                function e(e) {
                    function f(a) {
                        return angular.equals(a, k) && a.$priority === k.$priority && a.$value === k.$value
                    }

                    function g(a) {
                        j.assign(c, b.scopeData(a))
                    }

                    function h() {
                        var a = j(c);
                        return [a, a.$priority, a.$value]
                    }

                    var i = !1, j = a(d), k = e.rec;
                    e.scope = c, e.varName = d;
                    var l = b.debounce(function (a) {
                        var d = b.scopeData(a);
                        k.$$scopeUpdated(d).finally(function () {
                            i = !1, d.hasOwnProperty("$value") || (delete k.$value, delete j(c).$value), g(k)
                        })
                    }, 50, 500), m = function (a) {
                        a = a[0], f(a) || (i = !0, l(a))
                    }, n = function () {
                        i || f(j(c)) || g(k)
                    };
                    return g(k), e.subs.push(c.$on("$destroy", e.unbind.bind(e))), e.subs.push(c.$watch(h, m, !0)), e.subs.push(k.$watch(n)), e.unbind.bind(e)
                }

                return this.assertNotBound(d) || e(this)
            }, unbind: function () {
                this.scope && (angular.forEach(this.subs, function (a) {
                    a()
                }), this.subs = [], this.scope = null, this.key = null)
            }, destroy: function () {
                this.unbind(), this.rec = null
            }
        }, e
    }]), angular.module("firebase").factory("$FirebaseObject", ["$log", "$firebaseObject", function (a, b) {
        return function () {
            return a.warn("$FirebaseObject has been renamed. Use $firebaseObject instead."), b.apply(null, arguments)
        }
    }])
}(), function () {
    "use strict";

    function a() {
        this.urls = null, this.registerUrl = function (a) {
            "string" == typeof a && (this.urls = {}, this.urls.default = a), angular.isObject(a) && (this.urls = a)
        }, this.$$checkUrls = function (a) {
            return a ? a.default ? void 0 : new Error('No default Firebase URL registered. Use firebaseRefProvider.registerUrl({ default: "https://<my-firebase-app>.firebaseio.com/"}).') : new Error("No Firebase URL registered. Use firebaseRefProvider.registerUrl() in the config phase. This is required if you are using $firebaseAuthService.")
        }, this.$$createRefsFromUrlConfig = function (a) {
            var b = {}, c = this.$$checkUrls(a);
            if (c) throw c;
            return angular.forEach(a, function (a, c) {
                b[c] = firebase.database().refFromURL(a)
            }), b
        }, this.$get = function () {
            return this.$$createRefsFromUrlConfig(this.urls)
        }
    }

    angular.module("firebase.database").provider("$firebaseRef", a)
}(), function () {
    "use strict";
    angular.module("firebase").factory("$firebase", function () {
        return function () {
            throw new Error("$firebase has been removed. You may instantiate $firebaseArray and $firebaseObject directly now. For simple write operations, just use the Firebase ref directly. See the AngularFire 1.0.0 changelog for details: https://github.com/firebase/angularfire/releases/tag/v1.0.0")
        }
    })
}(), Array.prototype.indexOf || (Array.prototype.indexOf = function (a, b) {
    if (void 0 === this || null === this) throw new TypeError("'this' is null or not defined");
    var c = this.length >>> 0;
    for (b = +b || 0, Math.abs(b) === 1 / 0 && (b = 0), b < 0 && (b += c, b < 0 && (b = 0)); b < c; b++) if (this[b] === a) return b;
    return -1
}), Function.prototype.bind || (Function.prototype.bind = function (a) {
    if ("function" != typeof this) throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable");
    var b = Array.prototype.slice.call(arguments, 1), c = this, d = function () {
    }, e = function () {
        return c.apply(this instanceof d && a ? this : a, b.concat(Array.prototype.slice.call(arguments)))
    };
    return d.prototype = this.prototype, e.prototype = new d, e
}), Array.prototype.findIndex || Object.defineProperty(Array.prototype, "findIndex", {
    enumerable: !1,
    configurable: !0,
    writable: !0,
    value: function (a) {
        if (null == this) throw new TypeError("Array.prototype.find called on null or undefined");
        if ("function" != typeof a) throw new TypeError("predicate must be a function");
        for (var b, c = Object(this), d = c.length >>> 0, e = arguments[1], f = 0; f < d; f++) if (f in c && (b = c[f], a.call(e, b, f, c))) return f;
        return -1
    }
}), "function" != typeof Object.create && !function () {
    var a = function () {
    };
    Object.create = function (b) {
        if (arguments.length > 1) throw new Error("Second argument not supported");
        if (null === b) throw new Error("Cannot set a null [[Prototype]]");
        if ("object" != typeof b) throw new TypeError("Argument must be an object");
        return a.prototype = b, new a
    }
}(), Object.keys || (Object.keys = function () {
    "use strict";
    var a = Object.prototype.hasOwnProperty, b = !{toString: null}.propertyIsEnumerable("toString"),
        c = ["toString", "toLocaleString", "valueOf", "hasOwnProperty", "isPrototypeOf", "propertyIsEnumerable", "constructor"],
        d = c.length;
    return function (e) {
        if ("object" != typeof e && ("function" != typeof e || null === e)) throw new TypeError("Object.keys called on non-object");
        var f, g, h = [];
        for (f in e) a.call(e, f) && h.push(f);
        if (b) for (g = 0; g < d; g++) a.call(e, c[g]) && h.push(c[g]);
        return h
    }
}()), "function" != typeof Object.getPrototypeOf && ("object" == typeof "test".__proto__ ? Object.getPrototypeOf = function (a) {
    return a.__proto__
} : Object.getPrototypeOf = function (a) {
    return a.constructor.prototype
}), function () {
    "use strict";

    function a(a, c) {
        return {
            $progress: function (d) {
                a.on("state_changed", function () {
                    c.compile(function () {
                        d(b(a.snapshot))
                    })
                })
            },
            $error: function (b) {
                a.on("state_changed", null, function (a) {
                    c.compile(function () {
                        b(a)
                    })
                })
            },
            $complete: function (d) {
                a.on("state_changed", null, null, function () {
                    c.compile(function () {
                        d(b(a.snapshot))
                    })
                })
            },
            $cancel: a.cancel,
            $resume: a.resume,
            $pause: a.pause,
            then: a.then,
            catch: a.catch,
            $snapshot: a.snapshot
        }
    }

    function b(a) {
        return {
            bytesTransferred: a.bytesTransferred,
            downloadURL: a.downloadURL,
            metadata: a.metadata,
            ref: a.ref,
            state: a.state,
            task: a.task,
            totalBytes: a.totalBytes
        }
    }

    function c(a) {
        return a = a || {}, "function" == typeof a.put
    }

    function d(a) {
        if (!c(a)) throw new Error("$firebaseStorage expects a Storage reference")
    }

    function e(e, f) {
        var g = function (b) {
            return d(b), {
                $put: function (c, d) {
                    var f = b.put(c, d);
                    return a(f, e)
                }, $putString: function (c, d, f) {
                    var g = b.putString(c, d, f);
                    return a(g, e)
                }, $getDownloadURL: function () {
                    return f.when(b.getDownloadURL())
                }, $delete: function () {
                    return f.when(b.delete())
                }, $getMetadata: function () {
                    return f.when(b.getMetadata())
                }, $updateMetadata: function (a) {
                    return f.when(b.updateMetadata(a))
                }, $toString: function () {
                    return b.toString()
                }
            }
        };
        return g.utils = {_unwrapStorageSnapshot: b, _isStorageRef: c, _assertStorageRef: d}, g
    }

    angular.module("firebase.storage").factory("$firebaseStorage", ["$firebaseUtils", "$q", e])
}(), function () {
    "use strict";

    function a(a, b) {
        return {
            restrict: "A", priority: 99, scope: {}, link: function (c, d, e) {
                e.$observe("firebaseSrc", function (c) {
                    if ("" !== c) {
                        var e = b.storage().ref(c), f = a(e);
                        f.$getDownloadURL().then(function (a) {
                            d[0].src = a
                        })
                    }
                })
            }
        }
    }

    a.$inject = ["$firebaseStorage", "firebase"], angular.module("firebase.storage").directive("firebaseSrc", a)
}(), function () {
    "use strict";

    function a(b) {
        if (!angular.isObject(b)) return b;
        var c = angular.isArray(b) ? [] : {};
        return angular.forEach(b, function (b, d) {
            "string" == typeof d && "$" === d.charAt(0) || (c[d] = a(b))
        }), c
    }

    angular.module("firebase.utils").factory("$firebaseConfig", ["$firebaseArray", "$firebaseObject", "$injector", function (a, b, c) {
        return function (d) {
            var e = angular.extend({}, d);
            return "string" == typeof e.objectFactory && (e.objectFactory = c.get(e.objectFactory)), "string" == typeof e.arrayFactory && (e.arrayFactory = c.get(e.arrayFactory)), angular.extend({
                arrayFactory: a,
                objectFactory: b
            }, e)
        }
    }]).factory("$firebaseUtils", ["$q", "$timeout", "$rootScope", function (b, c, d) {
        var e = {
            batch: function (a, b) {
                return function () {
                    var c = Array.prototype.slice.call(arguments, 0);
                    e.compile(function () {
                        a.apply(b, c)
                    })
                }
            }, debounce: function (a, b, c, d) {
                function f() {
                    j && (j(), j = null), i && Date.now() - i > d ? l || (l = !0, e.compile(g)) : (i || (i = Date.now()), j = e.wait(g, c))
                }

                function g() {
                    j = null, i = null, l = !1, a.apply(b, k)
                }

                function h() {
                    k = Array.prototype.slice.call(arguments, 0), f()
                }

                var i, j, k, l;
                if ("number" == typeof b && (d = c, c = b, b = null), "number" != typeof c) throw new Error("Must provide a valid integer for wait. Try 0 for a default");
                if ("function" != typeof a) throw new Error("Must provide a valid function to debounce");
                return d || (d = 10 * c || 100), h.running = function () {
                    return i > 0
                }, h
            }, assertValidRef: function (a, b) {
                if (!angular.isObject(a) || "object" != typeof a.ref || "function" != typeof a.ref.transaction) throw new Error(b || "Invalid Firebase reference")
            }, inherit: function (a, b, c) {
                var d = a.prototype;
                return a.prototype = Object.create(b.prototype), a.prototype.constructor = a, angular.forEach(Object.keys(d), function (b) {
                    a.prototype[b] = d[b]
                }), angular.isObject(c) && angular.extend(a.prototype, c), a
            }, getPrototypeMethods: function (a, b, c) {
                for (var d = {}, e = Object.getPrototypeOf({}), f = angular.isFunction(a) && angular.isObject(a.prototype) ? a.prototype : Object.getPrototypeOf(a); f && f !== e;) {
                    for (var g in f) f.hasOwnProperty(g) && !d.hasOwnProperty(g) && (d[g] = !0, b.call(c, f[g], g, f));
                    f = Object.getPrototypeOf(f)
                }
            }, getPublicMethods: function (a, b, c) {
                e.getPrototypeMethods(a, function (a, d) {
                    "function" == typeof a && "_" !== d.charAt(0) && b.call(c, a, d)
                })
            }, makeNodeResolver: function (a) {
                return function (b, c) {
                    null === b ? (arguments.length > 2 && (c = Array.prototype.slice.call(arguments, 1)), a.resolve(c)) : a.reject(b)
                }
            }, wait: function (a, b) {
                var d = c(a, b || 0);
                return function () {
                    d && (c.cancel(d), d = null)
                }
            }, compile: function (a) {
                return d.$evalAsync(a || function () {
                })
            }, deepCopy: function (a) {
                if (!angular.isObject(a)) return a;
                var b = angular.isArray(a) ? a.slice() : angular.extend({}, a);
                for (var c in b) b.hasOwnProperty(c) && angular.isObject(b[c]) && (b[c] = e.deepCopy(b[c]));
                return b
            }, trimKeys: function (a, b) {
                e.each(a, function (c, d) {
                    b.hasOwnProperty(d) || delete a[d]
                })
            }, scopeData: function (a) {
                var b = {$id: a.$id, $priority: a.$priority}, c = !1;
                return e.each(a, function (a, d) {
                    c = !0, b[d] = e.deepCopy(a)
                }), !c && a.hasOwnProperty("$value") && (b.$value = a.$value), b
            }, updateRec: function (a, b) {
                var c = b.val(), d = angular.extend({}, a);
                return angular.isObject(c) ? delete a.$value : (a.$value = c, c = {}), e.trimKeys(a, c), angular.extend(a, c), a.$priority = b.getPriority(), !angular.equals(d, a) || d.$value !== a.$value || d.$priority !== a.$priority
            }, applyDefaults: function (a, b) {
                return angular.isObject(b) && angular.forEach(b, function (b, c) {
                    a.hasOwnProperty(c) || (a[c] = b)
                }), a
            }, dataKeys: function (a) {
                var b = [];
                return e.each(a, function (a, c) {
                    b.push(c)
                }), b
            }, each: function (a, b, c) {
                if (angular.isObject(a)) {
                    for (var d in a) if (a.hasOwnProperty(d)) {
                        var e = d.charAt(0);
                        "_" !== e && "$" !== e && "." !== e && b.call(c, a[d], d, a)
                    }
                } else if (angular.isArray(a)) for (var f = 0, g = a.length; f < g; f++) b.call(c, a[f], f, a);
                return a
            }, toJSON: function (b) {
                var c;
                return angular.isObject(b) || (b = {$value: b}), angular.isFunction(b.toJSON) ? c = b.toJSON() : (c = {}, e.each(b, function (b, d) {
                    c[d] = a(b)
                })), angular.isDefined(b.$value) && 0 === Object.keys(c).length && null !== b.$value && (c[".value"] = b.$value), angular.isDefined(b.$priority) && Object.keys(c).length > 0 && null !== b.$priority && (c[".priority"] = b.$priority), angular.forEach(c, function (a, b) {
                    if (b.match(/[.$\[\]#\/]/) && ".value" !== b && ".priority" !== b) throw new Error("Invalid key " + b + " (cannot contain .$[]#/)");
                    if (angular.isUndefined(a)) throw new Error("Key " + b + " was undefined. Cannot pass undefined in JSON. Use null instead.")
                }), c
            }, doSet: function (a, c) {
                var d = b.defer();
                if (angular.isFunction(a.set) || !angular.isObject(c)) try {
                    a.set(c, e.makeNodeResolver(d))
                } catch (a) {
                    d.reject(a)
                } else {
                    var f = angular.extend({}, c);
                    a.once("value", function (b) {
                        b.forEach(function (a) {
                            f.hasOwnProperty(a.key) || (f[a.key] = null)
                        }), a.ref.update(f, e.makeNodeResolver(d))
                    }, function (a) {
                        d.reject(a)
                    })
                }
                return d.promise
            }, doRemove: function (a) {
                var c = b.defer();
                return angular.isFunction(a.remove) ? a.remove(e.makeNodeResolver(c)) : a.once("value", function (b) {
                    var d = [];
                    b.forEach(function (a) {
                        d.push(a.ref.remove())
                    }), e.allPromises(d).then(function () {
                        c.resolve(a)
                    }, function (a) {
                        c.reject(a)
                    })
                }, function (a) {
                    c.reject(a)
                }), c.promise
            }, VERSION: "2.3.0", allPromises: b.all.bind(b)
        };
        return e
    }])
}();