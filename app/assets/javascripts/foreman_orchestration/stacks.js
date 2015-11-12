function stacksTenantSelected(item) {
  var $item = $(item);
  var tenant = $item.val();
  if (tenant === '') {
    return false;
  } else {
    var url = $item.data('url');
    var params = $.param({tenant: tenant});
    var $stacks = $('#stacks-list');
    $stacks.hide();
    $stacks.load(url, params, function () {
      $stacks.show();
    });
  }
}
