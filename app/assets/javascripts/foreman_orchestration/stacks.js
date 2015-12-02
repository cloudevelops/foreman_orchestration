function updateDefaultEntityButton(selector, defaultValue, currentValue) {
  var $button = $(selector);
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
    var url = $item.data('url').replace(':id', computeResource);
    var defaultValue = $item.data('default-value');
    var $tenants = $('#tenants-list');
    $('#stacks-list').empty();
    $tenants.empty();
    $tenants.load(url, function () {
      $tenants.find('select').select2({allowClear: true});
      $item.indicator_hide();
      updateDefaultEntityButton('#set-default-compute-resource', defaultValue, computeResource);
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
    var url = $item.data('url').replace(':id', tenant);
    var defaultValue = $item.data('default-value');
    var $stacks = $('#stacks-list');
    $stacks.empty();
    $stacks.load(url, function () {
      $item.indicator_hide();
      updateDefaultEntityButton('#set-default-tenant', defaultValue, tenant);
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

function setDefaultComputeResource(button) {
  var $button = $(button);
  var $select = $('#compute_resource');
  var computeResourceId = $select.val();
  if (!$button.data('processing') && computeResourceId !== '') {
    $button.data('processing', true);
    var url = $button.data('url').replace(':id', computeResourceId);
    var oldText = $button.text();
    $button.text($button.data('disable-with'));
    $.post(url).done(function () {
      $button.prop('disabled', true);
      $select.data('default-value', Number(computeResourceId));
    }).fail(function () {
      alert('Something went wrong');
    }).always(function () {
      $button.text(oldText);
      $button.data('processing', false);
    });
  }
  return false;
}

function setDefaultTenant(button) {
  var $button = $(button);
  var $select = $('#tenant');
  var tenantId = $select.val();
  if (!$button.data('processing') && tenantId !== '') {
    $button.data('processing', true);
    var url = $button.data('url').replace(':id', tenantId);
    var oldText = $button.text();
    $button.text($button.data('disable-with'));
    $.post(url).done(function () {
      $button.prop('disabled', true);
      $select.data('default-value', tenantId);
    }).fail(function () {
      alert('Something went wrong');
    }).always(function () {
      $button.text(oldText);
      $button.data('processing', false);
    });
  }
  return false;
}
