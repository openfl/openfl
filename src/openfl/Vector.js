var openfl;
(function (openfl) {
    var VectorDescriptor = {
        constructor: { value: null },
        concat: {
            value: function (a)
            {
                return Vector.ofArray(Array.prototype.concat.call(this, a));
            }
        },
        copy: {
            value: function ()
            {
                return Vector.ofArray(this);
            }
        },
        filter: {
            value: function (callback)
            {
                return Vector.ofArray(Array.prototype.filter.call(this, callback));
            }
        },
        get: {
            value: function (index)
            {
                return this[index];
            }
        },
        insertAt: {
            value: function (index, element)
            {
                if (!this.fixed || index < this.length)
                {
                    Array.prototype.splice.call(this, index, 0, element);
                }
            }
        },
        lastIndexOf: {
            value: function (x, from)
            {
                if (from == null)
                {
                    return Array.prototype.lastIndexOf.call(this, x);
                } else
                {
                    return Array.prototype.lastIndexOf.call(this, x, from);
                }
            }
        },
        pop: {
            value: function ()
            {
                if (!this.fixed)
                {
                    return Array.prototype.pop.call(this);
                } else
                {
                    return null;
                }
            }
        },
        push: {
            value: function (x)
            {
                if (!this.fixed)
                {
                    return Array.prototype.push.call(this, x);
                } else
                {
                    return this.length;
                }
            }
        },
        removeAt: {
            value: function (index)
            {
                if (!this.fixed || index < this.length)
                {
                    return Array.prototype.splice.call(this, index, 1)[0];
                }
                return null;
            }
        },
        set: {
            value: function (index, value)
            {
                if (!this.fixed || index < this.length)
                {
                    return this[index] = value;
                } else
                {
                    return value;
                }
            }
        },
        shift: {
            value: function ()
            {
                if (!this.fixed)
                {
                    return Array.prototype.shift.call(this);
                } else
                {
                    return null;
                }
            }
        },
        slice: {
            value: function (startIndex, endIndex)
            {
                if (startIndex == null)
                {
                    startIndex = 0;
                }
                if (endIndex == null)
                {
                    endIndex = 16777215;
                }
                return Vector.ofArray(Array.prototype.slice.call(this, startIndex, endIndex));
            }
        },
        splice: {
            value: function (pos, len)
            {
                return Vector.ofArray(Array.prototype.splice.call(this, pos, len));
            }
        },
        unshift: {
            value: function (x)
            {
                if (!this.fixed)
                {
                    Array.prototype.unshift.call(this, x);
                }
            }
        },
        get_length: {
            value: function ()
            {
                return this.length;
            }
        },
        set_length: {
            value: function (value)
            {
                if (!this.fixed)
                {
                    this.length = value;
                }
                return value;
            }
        }
    };

    var Vector = function (length, fixed, array) {
        if (array == null) array = [];
        if (length != null)
        {
            array.length = length;
        }
        array.fixed = fixed == true;
        return Object.defineProperties(array, VectorDescriptor);
    };

    Vector.ofArray = function (array) {
        if (array == null)
        {
            return null;
        }
        var data = new Vector();
        var i = 0;
        var count = a.length;
        while (i < count)
        {
            data[i] = array[i];
            i++;
        }
        return data;
    }

    Vector.name = "Vector";
    openfl.Vector = Vector;
})(openfl || (openfl = {}));
export default openfl.Vector;