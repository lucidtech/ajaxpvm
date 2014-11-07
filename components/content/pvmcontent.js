// Generated by CoffeeScript 1.6.2
(function() {
  var PVMRouting;

  ko.components.register('pvmcontent', {
    viewModel: PVMRouting = (function() {
      function PVMRouting() {
        this.currentView = ko.observable('settings');
        this.views = ko.observableArray(['clouds', 'users', 'groups', 'settings', 'methods']);
      }

      return PVMRouting;

    })(),
    template: {
      require: "/static/requirejs/text.js!views?template=content/content"
    }
  });

}).call(this);

/*
//@ sourceMappingURL=pvmcontent.map
*/