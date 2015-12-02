function updateDefaultComputeResourceButton(defaultValue, currentValue) {
  var $button = $('#set-default-compute-resource');
  if (currentValue == defaultValue || currentValue == '') {
    $button.prop('disabled', true);
  } else {
    $button.prop('disabled', false);
  }
}

function stacksComputeResourceSelected(item) {
  var $item = $(item);
  var computeResource = $item.val();
  if (computeResource === '') {
    return false;
  } else {
    $item.indicator_show();
    // TODO: use url helper somehow?
    var url = '/compute_resources/' + computeResource + '/tenants/for_select';
    var defaultValue = $item.data('default-value');
    var $tenants = $('#tenants-list');
    $('#stacks-list').empty();
    $tenants.empty();
    $tenants.load(url, function () {
      $tenants.find('select').select2({allowClear: true});
      $item.indicator_hide();
      updateDefaultComputeResourceButton(defaultValue, computeResource);
    });
  }
}

function stacksNewComputeResourceSelected(item) {
  var $item = $(item);
  var computeResource = $item.val();
  if (computeResource === '') {
    return false;
  } else {
    $item.indicator_show();
    var url = $item.data('url');
    var params = $.param({compute_resource_id: computeResource});
    var $main = $('#main-stack-parameters');
    $main.hide();
    var $container = $('#tenants-list-container');
    $container.empty();
    $container.load(url + ' #tenants-list', params, function () {
      $container.find('select').select2({allowClear: true});
      $main.show();
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
    var url = $item.data('url').replace(':template_id', templateId);
    var params = $.param({template_id: templateId});
    var $container = $('#template-with-params');
    $container.hide();
    $container.load(url, params, function () {
      $container.show();
      $item.indicator_hide();
    });
  }
}

function setDefaultComputeResource(item) {
  var $item = $(item);
  var $select = $('#compute_resource');
  var computeResourceId = $select.val();
  if (!$item.data('processing') && computeResourceId !== '') {
    $item.data('processing', true);
    var url = $item.data('url').replace(':id', computeResourceId);
    var oldText = $item.text();
    $item.text($item.data('disable-with'));
    $.post(url).done(function () {
      $item.prop('disabled', true);
      $select.data('default-value', Number(computeResourceId));
    }).fail(function () {
      // TODO: do something better?
      alert('Something went wrong');
    }).always(function () {
      $item.text(oldText);
      $item.data('processing', false);
    });
  }
  return false;
}