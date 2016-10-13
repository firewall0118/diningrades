(function ($) {
  "use strict";

  /* The basic svg string required to generate stars
   */
  /*
  var BASICSTAR = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"+
                  "<svg version=\"1.1\" id=\"Layer_1\""+
                        "xmlns=\"http://www.w3.org/2000/svg\""+
                        "viewBox=\"0 12.705 512 486.59\""+
                        "x=\"0px\" y=\"0px\""+
                        "xml:space=\"preserve\">"+
                    "<polygon id=\"star-icon\""+
                              "points=\"256.814,12.705 317.205,198.566"+
                                      " 512.631,198.566 354.529,313.435 "+
                                      "414.918,499.295 256.814,384.427 "+
                                      "98.713,499.295 159.102,313.435 "+
                                      "1,198.566 196.426,198.566 \"/>"+
                  "</svg>";
  */
  //var BASICSTAR = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" version=\"1.1\" x=\"0px\" y=\"0px\" viewBox=\"0 0 100 100\" enable-background=\"new 0 0 100 100\" xml:space=\"preserve\"><g><path d=\"M37.2,35c0-1.4-1.1-2.5-2.5-2.5c-9.5,0-17.2,7.6-17.2,17c0,1.4,1.1,2.5,2.5,2.5s2.5-1.1,2.5-2.5c0-6.6,5.5-12,12.2-12   C36.1,37.5,37.2,36.4,37.2,35z\"></path><path d=\"M38.4,95c1.6,0,3.3-0.2,4.8-0.6l6.7-1.7l6.7,1.7c1.6,0.4,3.2,0.6,4.8,0.6c5.3,0,10.4-2.1,14.1-5.8l0.2-0.2   c5.3-5.3,9.5-11.5,12.4-18.4l1.2-2.8l-3-0.6c-8.1-1.6-14-8.9-14-17.1c0-7,4.2-13.4,10.7-16.1l3.6-1.5l-2.8-2.6   c-5.1-4.7-11.6-7.3-18.6-7.3c-4.1,0-8.2,0.5-12.2,1.5l-0.6,0.1v-0.5c0-5.9,3.3-11.3,8.6-13.9l-2.2-4.5c-4.2,2.1-7.5,5.5-9.4,9.6   C45.3,8.7,38.3,5,30.9,5c-2.5,0-5,0.4-7.4,1.3l-3.1,1.1l1.8,2.7c4.2,6.2,11.2,10,18.7,10c2.4,0,4.8-0.4,7.2-1.2   c-0.4,1.6-0.6,3.2-0.6,4.9v0.5L46.9,24c-4-1-8.1-1.5-12.2-1.5c-15,0-27.2,12.1-27.2,27c0,14.9,6.1,29.4,16.8,39.8   C28.1,93,33.1,95,38.4,95z M28.8,10.1C34,9.5,39.3,11.3,43,14.9C37.7,15.5,32.5,13.7,28.8,10.1z M34.7,27.5c3.7,0,7.4,0.5,11,1.3   l4.3,1.1l4.3-1.1c3.6-0.9,7.3-1.3,11-1.3c4.4,0,8.7,1.3,12.3,3.7C71.4,35.3,67.5,42.3,67.5,50c0,9.6,6.2,18.1,15,21.2   c-2.5,5.3-5.9,10-10.1,14.2l-0.2,0.2c-2.8,2.8-6.6,4.4-10.6,4.4c-1.2,0-2.5-0.1-3.6-0.4l-7.9-2l-7.9,2c-1.2,0.3-2.4,0.4-3.7,0.4   c-4,0-7.7-1.5-10.6-4.3C18.1,76.2,12.5,63,12.5,49.4C12.5,37.3,22.5,27.5,34.7,27.5z\"></path></g></svg>";
  var BASICSTAR = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" version=\"1.1\" x=\"0px\" y=\"0px\" viewBox=\"0 0 100 100\" enable-background=\"new 0 0 100 100\" xml:space=\"preserve\"><g><path d=\"M86.5,67.1c-8.1-1.6-14-8.9-14-17.1c0-7,4.2-13.4,10.7-16.1l3.6-1.5l-2.8-2.6c-5.1-4.7-11.6-7.3-18.6-7.3   c-4.1,0-8.2,0.5-12.2,1.5l-0.6,0.1v-0.5c0-5.9,3.3-11.3,8.6-13.9l-2.2-4.5c-4.2,2.1-7.5,5.5-9.4,9.6C45.3,8.7,38.3,5,30.9,5   c-2.5,0-5,0.4-7.4,1.3l-3.1,1.1l1.8,2.7c4.2,6.2,11.2,10,18.7,10c2.4,0,4.8-0.4,7.2-1.2c-0.4,1.6-0.6,3.2-0.6,4.9v0.5L46.9,24   c-4-1-8.1-1.5-12.2-1.5c-15,0-27.2,12.1-27.2,27c0,14.9,6.1,29.4,16.8,39.8C28.1,93,33.1,95,38.4,95c1.6,0,3.3-0.2,4.8-0.6l6.7-1.7   l6.7,1.7c1.6,0.4,3.2,0.6,4.8,0.6c5.3,0,10.4-2.1,14.1-5.8l0.2-0.2c5.3-5.3,9.5-11.5,12.4-18.4l1.2-2.8L86.5,67.1z\"></path></g></svg>";

  var DEFAULTS = {

    starWidth: "20px",
    normalFill: "gray",
    ratedFill: "red", //"#E66559",
    numStars: 5,
    maxValue: 5,
    precision: 1,
    rating: 0,
    fullStar: false,
    halfStar: false,
    readOnly: false,
    spacing: "0px",
    onChange: null,
    onSet: null
  };

  function checkPrecision (value, minValue, maxValue) {

    /* its like comparing 0.00 with 0 which is true*/
    if (value === minValue) {

      value = minValue;
    }
    else if(value === maxValue) {

      value = maxValue;
    }

    return value;
  }

  function checkBounds (value, minValue, maxValue) {

    var isValid = value >= minValue && value <= maxValue;

    if(!isValid){

        throw Error("Invalid Rating, expected value between "+ minValue +
                    " and " + maxValue);
    }

    return value;
  }

  function getInstance (node, collection) {

    var instance;

    $.each(collection, function () {

      if(node === this.node){

        instance = this;
        return false;
      }
    });

    return instance;
  }

  function deleteInstance (node, collection) {

    $.each(collection, function (index) {

      if (node === this.node) {

        var firstPart = collection.slice(0, index),
            secondPart = collection.slice(index+1, collection.length);

        collection = firstPart.concat(secondPart);

        return false;
      }
    });

    return collection;
  }

  function isDefined(value) {

    return typeof value !== "undefined";
  }

  /* The Contructor, whose instances are used by plugin itself,
   * to set and get values
   */
  function RateYo ($node, options) {

    this.$node = $node;

    this.node = $node.get(0);

    var that = this;

    $node.addClass("jq-ry-container");

    var $groupWrapper = $("<div/>").addClass("jq-ry-group-wrapper")
                                   .appendTo($node);

    var $normalGroup = $("<div/>").addClass("jq-ry-normal-group")
                                  .addClass("jq-ry-group")
                                  .appendTo($groupWrapper);

    var $ratedGroup = $("<div/>").addClass("jq-ry-rated-group")
                                 .addClass("jq-ry-group")
                                 .appendTo($groupWrapper);

    var step, starWidth, percentOfStar, spacing,
        percentOfSpacing, containerWidth, minValue = 0;

    function showRating (ratingVal) {

      if(!isDefined(ratingVal)){
        ratingVal = options.rating;
      }

      var numStarsToShow = ratingVal/step;

      var percent = numStarsToShow*percentOfStar;

      if (numStarsToShow > 1) {

        percent += (Math.ceil(numStarsToShow) - 1)*percentOfSpacing;
      }

      $ratedGroup.css("width", percent + "%");
    }

    function setContainerWidth () {

      containerWidth = starWidth*options.numStars;

      containerWidth += spacing*(options.numStars - 1);

      percentOfStar = (starWidth/containerWidth)*100;

      percentOfSpacing = (spacing/containerWidth)*100;

      $node.width(containerWidth);

      showRating();
    }

    function setStarWidth (newWidth) {

      if (!isDefined(newWidth)) {

        return options.starWidth;
      }

      // In the current version, the width and height of the star
      // should be the same
      options.starWidth = options.starHeight = newWidth;

      starWidth = parseFloat(options.starWidth.replace("px", ""));
 
      $normalGroup.find("svg")
                  .attr({width: options.starWidth,
                         height: options.starHeight});

      $ratedGroup.find("svg")
                 .attr({width: options.starWidth,
                        height: options.starHeight});

      setContainerWidth();
       
      return $node;
    }

    function setSpacing (newSpacing) {
      
      if (!isDefined(newSpacing)) {
      
        return options.spacing;  
      }

      options.spacing = newSpacing;

      spacing = parseFloat(options.spacing.replace("px", ""));

      $normalGroup.find("svg:not(:first-child)")
                  .css({"margin-left": newSpacing});

      $ratedGroup.find("svg:not(:first-child)")
                 .css({"margin-left": newSpacing}); 

      setContainerWidth();

      return $node;
    }

    function setNormalFill (newFill) {

      if (!isDefined(newFill)) {

        return options.normalFill;
      }

      options.normalFill = newFill;

      $normalGroup.find("svg").attr({fill: options.normalFill});

      return $node;
    }

    function setRatedFill (newFill) {

      if (!isDefined(newFill)) {

        return options.ratedFill;
      }

      options.ratedFill = newFill;

      $ratedGroup.find("svg").attr({fill: options.ratedFill});

      return $node;
    }

    function setNumStars (newValue) {

      if (!isDefined(newValue)) {

        return options.numStars;
      }

      options.numStars = newValue;

      step = options.maxValue/options.numStars;

      $normalGroup.empty();
      $ratedGroup.empty();

      for (var i=0; i<options.numStars; i++) {

        $normalGroup.append($(BASICSTAR));
        $ratedGroup.append($(BASICSTAR));
      }

      setStarWidth(options.starWidth);
      setRatedFill(options.ratedFill);
      setNormalFill(options.normalFill);
      setSpacing(options.spacing);

      showRating();

      return $node;
    }

    function setMaxValue (newValue) {

      if (!isDefined(newValue)) {

        return options.maxValue;
      }

      options.maxValue = newValue;

      step = options.maxValue/options.numStars;

      if (options.rating > newValue) {
      
        setRating(newValue); 
      }

      showRating();

      return $node;
    }

    function setPrecision (newValue) {

      if (!isDefined(newValue)) {

        return options.precision;
      }

      options.precision = newValue;

      showRating();

      return $node;
    }

    function setHalfStar (newValue) {

      if (!isDefined(newValue)) {
      
        return options.halfStar;  
      }

      options.halfStar = newValue;

      return $node;
    }

    function setFullStar (newValue) {
    
      if (!isDefined(newValue))   {
      
        return options.fullStar;  
      }

      options.fullStar = newValue;

      return $node;
    }

    function round (value) {
      
      var remainder = value%step,
          halfStep = step/2,
          isHalfStar = options.halfStar,
          isFullStar = options.fullStar;

      if (!isFullStar && !isHalfStar) {
      
        return value;  
      }

      if (isFullStar || (isHalfStar && remainder > halfStep)) {
      
        value += step - remainder;
      } else {
      
        value = value - remainder;
        
        if (remainder > 0) {
          
          value += halfStep;
        }
      }

      return value;
    }

    function calculateRating (e) {

      var position = $normalGroup.offset(),
          nodeStartX = position.left,
          nodeEndX = nodeStartX + $normalGroup.width();

      var maxValue = options.maxValue;

      var pageX = e.pageX;

      var calculatedRating = 0;

      if(pageX < nodeStartX) {

        calculatedRating = minValue;
      }else if (pageX > nodeEndX) {

        calculatedRating = maxValue;
      }else {

        var calcPrcnt = ((pageX - nodeStartX)/(nodeEndX - nodeStartX));

        if (spacing > 0) {

          calcPrcnt *= 100;

          var remPrcnt = calcPrcnt;

          while (remPrcnt > 0) {
            
            if (remPrcnt > percentOfStar) {

              calculatedRating += step;
              remPrcnt -= (percentOfStar + percentOfSpacing);
            } else {

              calculatedRating += remPrcnt/percentOfStar*step;
              remPrcnt = 0;
            }  
          }
        } else {
        
          calculatedRating = calcPrcnt * (options.maxValue);  
        }

        calculatedRating = round(calculatedRating);
      }

      return calculatedRating;
    }

    function onMouseEnter (e) {

      var rating = calculateRating(e).toFixed(options.precision);

      var maxValue = options.maxValue;

      rating = checkPrecision(parseFloat(rating), minValue, maxValue);

      showRating(rating);

      $node.trigger("rateyo.change", {rating: rating});
    }

    function onMouseLeave () {

      showRating();

      $node.trigger("rateyo.change", {rating: options.rating});
    }

    function onMouseClick (e) {

      var resultantRating = calculateRating(e).toFixed(options.precision);
      resultantRating = parseFloat(resultantRating);

      that.rating(resultantRating);
    }

    function onChange (e, data) {

      if(options.onChange && typeof options.onChange === "function") {

        /* jshint validthis:true */
        options.onChange.apply(this, [data.rating, that]);
      }
    }

    function onSet (e, data) {

      if(options.onSet && typeof options.onSet === "function") {

        /* jshint validthis:true */
        options.onSet.apply(this, [data.rating, that]);
      }
    }

    function bindEvents () {

      $node.on("mousemove", onMouseEnter)
           .on("mouseenter", onMouseEnter)
           .on("mouseleave", onMouseLeave)
           .on("click", onMouseClick)
           .on("rateyo.change", onChange)
           .on("rateyo.set", onSet);
    }

    function unbindEvents () {

      $node.off("mousemove", onMouseEnter)
           .off("mouseenter", onMouseEnter)
           .off("mouseleave", onMouseLeave)
           .off("click", onMouseClick)
           .off("rateyo.change", onChange)
           .off("rateyo.set", onSet);
    }

    function setReadOnly (newValue) {

      if (!isDefined(newValue)) {

        return options.readOnly;
      }

      options.readOnly = newValue;

      $node.attr("readonly", true);

      unbindEvents();

      if (!newValue) {

        $node.removeAttr("readonly");

        bindEvents();
      }

      return $node;
    }

    function setRating (newValue) {

      if (!isDefined(newValue)) {

        return options.rating;
      }

      var rating = newValue;

      var maxValue = options.maxValue;

      if (typeof rating === "string") {

        if (rating[rating.length - 1] === "%") {

          rating = rating.substr(0, rating.length - 1);
          maxValue = 100;

          setMaxValue(maxValue);
        }

        rating = parseFloat(rating);
      }

      checkBounds(rating, minValue, maxValue);

      rating = parseFloat(rating.toFixed(options.precision));

      checkPrecision(parseFloat(rating), minValue, maxValue);

      options.rating = rating;

      showRating();

      $node.trigger("rateyo.set", {rating: rating});

      return $node;
    }

    function setOnSet (method) {

      if (!isDefined(method)) {

        return options.onSet;
      }

      options.onSet = method;

      return $node;
    }

    function setOnChange (method) {

      if (!isDefined(method)) {

        return options.onChange;
      }

      options.onChange = method;

      return $node;
    }

    this.rating = function (newValue) {

      if (!isDefined(newValue)) {

        return options.rating;
      }

      setRating(newValue);

      return $node;
    };

    this.destroy = function () {

      if (!options.readOnly) {
        unbindEvents();
      }

      RateYo.prototype.collection = deleteInstance($node.get(0),
                                                   this.collection);

      $node.removeClass("jq-ry-container").children().remove();

      return $node;
    };

    this.method = function (methodName) {

      if (!methodName) {

        throw Error("Method name not specified!");
      }

      if (!isDefined(this[methodName])) {

        throw Error("Method " + methodName + " doesn't exist!");
      }

      var args = Array.prototype.slice.apply(arguments, []),
          params = args.slice(1),
          method = this[methodName];

      return method.apply(this, params);
    };

    this.option = function (optionName, param) {

      if (!isDefined(optionName)) {

        return options;
      }

      var method;

      switch (optionName) {

        case "starWidth":

          method = setStarWidth;
          break;
        case "numStars":

          method = setNumStars;
          break;
        case "normalFill":

          method = setNormalFill;
          break;
        case "ratedFill":

          method = setRatedFill;
          break;
        case "maxValue":

          method = setMaxValue;
          break;
        case "precision":

          method = setPrecision;
          break;
        case "rating":

          method = setRating;
          break;
        case "halfStar":

          method = setHalfStar;
          break;
        case "fullStar":
        
          method = setFullStar;
          break;
        case "readOnly":

          method = setReadOnly;
          break;
        case "spacing":
        
          method = setSpacing;
          break;
        case "onSet":

          method = setOnSet;
          break;
        case "onChange":

          method = setOnChange;
          break;
        default:

          throw Error("No such option as " + optionName);
      }

      return method(param);
    };

    setNumStars(options.numStars);
    setReadOnly(options.readOnly);

    this.collection.push(this);
    this.rating(options.rating);
  }

  RateYo.prototype.collection = [];

  window.RateYo = RateYo;

  function _rateYo (options) {

    var rateYoInstances = RateYo.prototype.collection;

    /* jshint validthis:true */
    var $nodes = $(this);

    if($nodes.length === 0) {

      return $nodes;
    }

    var args = Array.prototype.slice.apply(arguments, []);

    if (args.length === 0) {

      //Setting Options to empty
      options = args[0] = {};
    }else if (args.length === 1 && typeof args[0] === "object") {

      //Setting options to first argument
      options = args[0];
    }else if (args.length >= 1 && typeof args[0] === "string") {

      var methodName = args[0],
          params = args.slice(1);

      var result = [];

      $.each($nodes, function (i, node) {

        var existingInstance = getInstance(node, rateYoInstances);

        if(!existingInstance) {

          throw Error("Trying to set options before even initialization");
        }

        var method = existingInstance[methodName];

        if (!method) {

          throw Error("Method " + methodName + " does not exist!");
        }

        var returnVal = method.apply(existingInstance, params);

        result.push(returnVal);
      });

      result = result.length === 1? result[0]: $(result);

      return result;
    }else {

      throw Error("Invalid Arguments");
    }

    options = $.extend(JSON.parse(JSON.stringify(DEFAULTS)), options);

    return $.each($nodes, function () {

              var existingInstance = getInstance(this, rateYoInstances);

              if (!existingInstance) {
                var val = $(this).data("rating");
                if(typeof val !== "undefined") {
                  options.rating = parseFloat(val);
                }
                
                return new RateYo($(this), $.extend({}, options));
              }
           });
  }

  function rateYo () {

    /* jshint validthis:true */
    return _rateYo.apply(this, Array.prototype.slice.apply(arguments, []));
  }

  $.fn.rateYo = rateYo;

}(jQuery));
