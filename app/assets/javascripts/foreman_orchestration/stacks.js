function stacksTenantSelected(item) {
  var $item = $(item);
  var tenant = $item.val();
  if (tenant === '') {
    return false;
  } else {
    $item.indicator_show();
    var url = $item.data('url');
    var params = $.param({tenant: tenant});
    var $stacks = $('#stacks-list');
    $stacks.hide();
    $stacks.load(url, params, function () {
      $stacks.show();
      $item.indicator_hide();
    });
  }
}

function stacksLoadTemplateWithParams(item) {
  var $item = $(item);
  var templateId = $item.val();
  if (templateId === '') {
    return false;
  } else {
    $item.indicator_show();
    var url = $item.data('url');
    var params = $.param({template_id: templateId});
    var $container = $('#template-with-params');
    $container.load(url, params, function () {
      $item.indicator_hide();
    });
  }
}