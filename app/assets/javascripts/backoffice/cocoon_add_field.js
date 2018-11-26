function addNestedField(button_element) {
  var $this                 = button_element,
      assoc                 = $this.data('association'),
      assocs                = $this.data('associations'),
      content               = $this.data('association-insertion-template'),
      insertionMethod       = $this.data('association-insertion-method') || $this.data('association-insertion-position') || 'before',
      insertionNode         = $this.data('association-insertion-node'),
      insertionTraversal    = $this.data('association-insertion-traversal'),
      count                 = parseInt($this.data('count'), 10),
      regexp_braced         = new RegExp('\\[new_' + assoc + '\\](.*?\\s)', 'g'),
      regexp_underscord     = new RegExp('_new_' + assoc + '_(\\w*)', 'g'),
      new_id                = create_new_id(),
      new_content           = content.replace(regexp_braced, newcontent_braced(new_id)),
      new_contents          = [];


  if (new_content == content) {
    regexp_braced     = new RegExp('\\[new_' + assocs + '\\](.*?\\s)', 'g');
    regexp_underscord = new RegExp('_new_' + assocs + '_(\\w*)', 'g');
    new_content       = content.replace(regexp_braced, newcontent_braced(new_id));
  }

  new_content = new_content.replace(regexp_underscord, newcontent_underscord(new_id));
  new_contents = [new_content];

  count = (isNaN(count) ? 1 : Math.max(count, 1));
  count -= 1;

  while (count) {
    new_id      = create_new_id();
    new_content = content.replace(regexp_braced, newcontent_braced(new_id));
    new_content = new_content.replace(regexp_underscord, newcontent_underscord(new_id));
    new_contents.push(new_content);

    count -= 1;
  }

  var insertionNodeElem = getInsertionNodeElem(insertionNode, insertionTraversal, $this)

  if( !insertionNodeElem || (insertionNodeElem.length == 0) ){
    console.warn("Couldn't find the element to insert the template. Make sure your `data-association-insertion-*` on `link_to_add_association` is correct.")
  }

  $.each(new_contents, function(i, node) {
    var contentNode = $(node);

    var before_insert = jQuery.Event('cocoon:before-insert');
    insertionNodeElem.trigger(before_insert, [contentNode]);

    if (!before_insert.isDefaultPrevented()) {
      // allow any of the jquery dom manipulation methods (after, before, append, prepend, etc)
      // to be called on the node.  allows the insertion node to be the parent of the inserted
      // code and doesn't force it to be a sibling like after/before does. default: 'before'
      var addedContent = insertionNodeElem[insertionMethod](contentNode);

      insertionNodeElem.trigger('cocoon:after-insert', [contentNode]);
    }
  });
}

var cocoon_element_counter = 0;

var create_new_id = function() {
  return (new Date().getTime() + cocoon_element_counter++);
}

var newcontent_braced = function(id) {
  return '[' + id + ']$1';
}

var newcontent_underscord = function(id) {
  return '_' + id + '_$1';
}

var getInsertionNodeElem = function(insertionNode, insertionTraversal, $this){

  if (!insertionNode){
    return $this.parent();
  }

  if (typeof insertionNode == 'function'){
    if(insertionTraversal){
      console.warn('association-insertion-traversal is ignored, because association-insertion-node is given as a function.')
    }
    return insertionNode($this);
  }

  if(typeof insertionNode == 'string'){
    if (insertionTraversal){
      return $this[insertionTraversal](insertionNode);
    }else{
      return insertionNode == "this" ? $this : $(insertionNode);
    }
  }

}