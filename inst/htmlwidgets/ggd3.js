HTMLWidgets.widget({

  name: 'ggd3',

  type: 'output',

  initialize: function(el, width, height) {

    var plot = ggd3.plot();

    // this is the "instance" in resize and renderValue
    return {
      plot: plot
    }

  },
  resize: function(el, width, height, instance) {
    d3.select(el)
      .select('svg')
      .attr('width', width)
      .attr('height', height);
  },

  renderValue: function(el, x, instance) {

    // x is list of data, layers, geoms, aes, settings
    var data = HTMLWidgets.dataframeToD3(x.data),
        plot = instance.plot,
        aes = x.aes || {},
        layerObjects = x.layers || {},
        geomObjects = x.geoms || {},
        layers = [],
        geoms = [],
        attr,
        layer,
        geom,
        settings = x.settings;

    // loop through plot settings in x and tack them on  plot
    console.log(settings.facet);
    for(var s in settings){
      // adding functions requires more work
      if((s === 'xScale' || s === 'yScale') &&
          settings[s].hasOwnProperty('axis') &&
          settings[s].axis.hasOwnProperty('tickFormat')){
        settings[s].axis.tickFormat = eval(settings[s].axis.tickFormat);
      }
      plot[s](settings[s]);
    }
    // layerObjects is an object with layer object as values
    var layerKeys = Object.keys(layerObjects);
    if(layerKeys.length > 0){
      for(layer in layerKeys){
        layers.push(processLayer(layerObjects[layerKeys[layer]]));
      }
    }
    // geomObjects is an object with geom objects as values
    var geomKeys = Object.keys(geomObjects);
    if(geomKeys.length > 0){
      for(geom in geomKeys){
        layers.push(processGeom(geomObjects[geomKeys[geom]]));
      }
    }

    plot
      .aes(aes)
      .layers([])
      .layers(layers)
      .data(data)
      .draw(d3.select(el))

    function processLayer(layer) {
      // layer is an object that may have a geom in it.
      var l = new ggd3.layer(),
          keys = Object.keys(layer);
      for(var i in keys){
        var attr = keys[i];
        if(attr == 'geom' && typeof layer[attr] === 'object'){
          l[attr](processGeom(layer[attr]));
        } else {
          l[attr](layer[attr]);
        }
      }
      return l;
    }

    function processGeom(geom) {
      var g = new ggd3.geoms[geom.type](),
          keys = Object.keys(geom);
      for(var i in keys){
        var attr = keys[i];
        if(attr !== 'type'){
          if(attr === 'tooltip'){
            var tt = new Function('el', 'd', 's', geom[attr]);
            g[attr](tt);
          } else {
            g[attr](geom[attr]);
          }
        }
      }
      return g;
    }
  }
});
