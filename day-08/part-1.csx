using System.IO;

var lines = File.ReadAllLines("i");
int count = 0;

for (int x = 0; x < lines[0].Length; x++)
{
	for (int y = 0; y < lines.Length; y++)
	{
		bool isVisible = VisibleUp(lines, x, y)
			|| VisibleDown(lines, x, y)
			|| VisibleLeft(lines, x, y)
			|| VisibleRight(lines, x, y);

		count += isVisible ? 1 : 0;
	}
}

Console.WriteLine(count);

bool VisibleUp(string[] trees, int treeX, int treeY)
{
	int tall = trees[treeY][treeX];
	for (int i = treeY - 1; i >= 0; i--)
	{
		if (trees[i][treeX] >= tall)
		{
			return false;
		}
	}
	return true;
}

bool VisibleDown(string[] trees, int treeX, int treeY)
{
	int tall = trees[treeY][treeX];
	for (int i = treeY + 1; i < trees.Length; i++)
	{
		if (trees[i][treeX] >= tall)
		{
			return false;
		}
	}
	return true;
}

bool VisibleLeft(string[] trees, int treeX, int treeY)
{
	int tall = trees[treeY][treeX];
	for (int i = treeX - 1; i >= 0; i--)
	{
		if (trees[treeY][i] >= tall)
		{
			return false;
		}
	}
	return true;
}

bool VisibleRight(string[] trees, int treeX, int treeY)
{
	int tall = trees[treeY][treeX];
	for (int i = treeX + 1; i < trees[0].Length; i++)
	{
		if (trees[treeY][i] >= tall)
		{
			return false;
		}
	}
	return true;
}
