require "./spec_helper"

include Graphlb::DataStructures

describe Graphlb do

  root = TreeNode.new("ROOT", 1)
  child1 = TreeNode.new("Child1", 2)
  child2 = TreeNode.new("Child2", 3)
  child3 = TreeNode.new("Child3", 4)
  child4 = TreeNode.new("Child4", 5)
  child5 = TreeNode.new("Child5", 6)

  root << child1
  root << child2
  root << child3 << child4

  puts (root.print_tree)
  # root method testcases
  it "roots root should be self" do
    ans = root.root
    true.should eq(root == ans)
  end

  it "Root should be ROOT" do
    ans = child1.root
    true.should eq(root == ans)
  end
  it "Root should be ROOT" do
    ans = child4.root
    true.should eq(root == ans)
  end

  # is_root? method testcases
  it "check if root is root" do
    ans = root.is_root?
    true.should eq(ans)
  end

  it "check if child1 is root" do
    ans = child1.is_root?
    true.should eq(!ans)
  end

  # has_content method testcases
  it "check if root node has content" do
    ans = root.has_content?
    true.should eq(ans)
  end

  # is_leaf method testcases
  it "check if root node is leaf node" do
    ans = root.is_leaf?
    true.should eq(!ans)
  end

  it "check if child5 is leaf node" do
    ans = child5.is_leaf?
    true.should eq(ans)
  end

  # has_children method testcases
  it "check if root node has children" do
    ans = root.has_children?
    true.should eq(ans)
  end

  it "check if child5 has children" do
    ans = child5.has_children?
    true.should eq(!ans)
  end

  # first_sibling method testcases
  it "get the first sibling of the node" do
    ans = child1.first_sibling
    true.should eq(ans == child1)
  end

  it "get the first sibling of the root node" do
    ans = root.first_sibling
    true.should eq(ans == root)
  end

  # last_sibling method testcases
  it "get the last sibling of the node" do
    ans = child1.last_sibling
    true.should eq(!(ans == child1))
  end

  it "get the last sibling of the root node" do
    ans = root.last_sibling
    true.should eq((ans == root))
  end

  # is_first_sibling? method testcases
  it "check if the self is the first sibling" do
    ans = child1.is_first_sibling?
    true.should eq(ans)
  end

  it "check if the child4 is the first sibling" do
    ans = child3.is_first_sibling?
    true.should eq(!ans)
  end

  # is_last_sibling? method testcases
  it "check if the self is the last sibling" do
    ans = child1.is_last_sibling?
    true.should eq(!ans)
  end

  it "check if the child4 is the last sibling" do
    ans = child4.is_last_sibling?
    true.should eq(ans)
  end

  # is_only_child? method testcases
  it "check if the self is the only child of its parent" do
    ans = child1.is_only_child?
    true.should eq(!ans)
  end

  it "check if the root node the only child of its parent" do
    ans = root.is_only_child?
    true.should eq(ans)
  end

  # next_sibling method root
  it "to get the next sibling of the root node" do
    ans = root.next_sibling
    true.should eq(ans.nil?)
  end

  it "to get next sibling of the child1 node" do
    ans = child1.next_sibling
    true.should eq(child2 == ans)
  end

  # previous_sibling method root
  it "to get the previous sibling of the root node" do
    ans = root.previous_sibling
    true.should eq(ans.nil?)
  end

  it "to get previous sibling of the child2 node" do
    ans = child2.previous_sibling
    true.should eq(child1 == ans)
  end

  # siblings method testcases
  it "to get all the siblings of the root node" do
    ans = root.siblings
    true.should eq(ans.size == 0)
  end

  it "to get all the siblings of the child1 node" do
    ans = child1.siblings
    true.should eq(ans.size == 2)
  end

  # parentage method testcases
  it "get all the parents of root node" do
    ans = root.parentage
    true.should eq(ans.nil?)
  end

  it "get all the parents of the child4 node" do
    ans = child4.parentage
    true.should eq(ans.not_nil!.size == 2)
  end

  # children method testcases
  it "get all the children of root node" do
    ans = root.children
    true.should eq(ans.not_nil!.size == 3)
  end

  it "get all the children of child5 node" do
    ans = child5.children
    true.should eq(ans.not_nil!.size == 0)
  end




end
