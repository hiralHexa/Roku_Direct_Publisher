function ContentHelpers() as object
  this = {}

  ' ********************************************
  ' ContentHelpers.oneDimList2ContentNode()
  '
  ' Parameters:
  '     arr       - one dimensional array of associative arrays with key/values to place into ContentNode
  '     node_type - string of the type of content node to be made
  '
  ' Usage
  '   one_dimensional_array = [
  '     {title: "My First Button"},
  '     {title: "My Second Button"}
  '   ]
  '   my_labellist.content = m.content_helpers.oneDimList2ContentNode(one_dimensional_array, "ButtonNode")
  ' ********************************************

  this.oneDimSingleItem2ContentNode = function(item as object, node_type as string)
      content = CreateObject("roSGNode", node_type)
      for each key in item
          if content[key] <> invalid
              content[key] = item[key]
          end if
      end for
      return content
  end function

  this.oneDimList2ContentNode = function(arr as object, node_type as string, key = invalid as object)
      row = CreateObject("roSGNode", "ContentNode")
      for each item in arr
          if key <> invalid and item[key] <> invalid
              content = m.oneDimSingleItem2ContentNode(item[key],node_type)
          else
              content = m.oneDimSingleItem2ContentNode(item,node_type)
          end if
          row.appendChild(content)
      end for
      return row
  end function

  this.twoDimList2ContentNode = function(two_d_arr as object, node_type as string)
      content_container = CreateObject("roSGNode", "ContentNode")
      for each row in two_d_arr
          row_content = m.oneDimList2ContentNode(row, node_type)
          content_container.appendChild(row_content)
      end for

      return content_container
    end function

    this.CountOneDimContentNode = function(content_node as object) as integer
        if content_node = invalid
            return 0
        end if
        return content_node.GetChildCount()
    end function

    this.CountTwoDimContentNodeAtIndex = function(content_node as object, row_index as integer) as integer
        if content_node = invalid
            return 0
        end if
        return content_node.GetChild(row_index).GetChildCount()
    end function

    this.AppendChildsToOneDimContentNode = function(content_node as object,  append_nodes as object) as object
        if content_node <> invalid and append_nodes <> invalid
            if append_nodes.getChildCount() = 0
                return content_node
            end if

            for i=0 to append_nodes.getChildCount() - 1 step 1
                content = append_nodes.getChild(i)
                content_node.appendChild(content)
            end for
            return content_node
        end if
    end function

    this.AppendToOneDimContentNode = function(content_node as object, arr as object, node_type as string) as object
        if content_node <> invalid and arr <> invalid
            if arr.count() = 0
                return content_node
            end if

            for each item in arr
                content = CreateObject("roSGNode", node_type)
                for each key in item
                    content[key] = item[key]
                end for
                content_node.appendChild(content)
            end for

            return content_node
        end if
    end function

    this.AppendToTwoDimContentNodeAtIndex = function(content_node as object, arr as object, row_index as integer, node_type as string) as object
        if content_node <> invalid and arr <> invalid
            if arr.count() = 0
                return content_node
            end if

            for each item in arr
                content = CreateObject("roSGNode", node_type)
                for each key in item
                    content[key] = item[key]
                end for
                content_node.GetChild(row_index).appendChild(content)
            end for
            return content_node
        end if
    end function

    this.PopOneDimContentNode = function(content_node as object) as object
        if content_node <> invalid and content_node.GetChildCount() > 0
            content_node.removeChildIndex(content_node.GetChildCount() - 1)
            return content_node
        else
            return CreateObject("roSGNode", "ContentNode")
        end if
    end function

    this.PopTwoDimContentNodeAtIndex = function(content_node as object, row_index as integer) as object
        if content_node <> invalid and content_node.GetChildCount() > 0
            content_node.GetChild(row_index).removeChildIndex(content_node.GetChild(row_index).GetChildCount() - 1)
            return content_node
        else
            return CreateObject("roSGNode", "ContentNode")
        end if
    end function

    return this
end function
