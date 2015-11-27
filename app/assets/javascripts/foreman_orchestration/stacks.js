function stacksComputeResourceSelected(item) {
  var $item = $(item);
  var computeResource = $item.val();
  if (computeResource === '') {
    return false;
  } else {
    $item.indicator_show();
    // TODO: use url helper somehow?
    var url = '/compute_resources/' + computeResource + '/tenants/for_select';
    var $tenants = $('#tenants-list');
    $('#stacks-list').empty();
    $tenants.empty();
    $tenants.load(url, function () {
      $tenants.find('select').select2({allowClear: true});
      $item.indicator_hide();
    });
  }
}

function stacksTenantSelected(item) {
  var $item = $(item);
  var tenant = $item.val();
  if (tenant === '') {
    return false;
  } else {
    $item.indicator_show();
    var url = $item.data('url') + '/' + tenant + '/stacks';
    var $stacks = $('#stacks-list');
    $stacks.empty();
    $stacks.load(url, function () {
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