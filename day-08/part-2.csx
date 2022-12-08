using System.IO;

var lines = File.ReadAllLines("i");
int max = 0;

for (int x = 0; x < lines[0].Length; x++)
{
	for (int y = 0; y < lines.Length; y++)
	{
		int visible = VisibleUp(lines, x, y)
			* VisibleDown(lines, x, y)
			* VisibleLeft(lines, x, y)
			* VisibleRight(lines, x, y);

		if (visible > max)
		{
			max = visible;
		}
	}
}

Console.WriteLine(max);

int VisibleUp(string[] trees, int treeX, int treeY)
{
	int tall = trees[treeY][treeX];
	for (int i = treeY - 1; i >= 0; i--)
	{
		if (trees[i][treeX] >= tall)
		{
			return treeY - i;
		}
	}
	return treeY;
}

int VisibleDown(string[] trees, int treeX, int treeY)
{
	int tall = trees[treeY][treeX];
	for (int i = treeY + 1; i < trees.Length; i++)
	{
		if (trees[i][treeX] >= tall)
		{
			return i - treeY;
		}
	}
	return trees.Length - treeY - 1;
}

int VisibleLeft(string[] trees, int treeX, int treeY)
{
	int tall = trees[treeY][treeX];
	for (int i = treeX - 1; i >= 0; i--)
	{
		if (trees[treeY][i] >= tall)
		{
			return treeX - i;
		}
	}
	return treeX;
}

int VisibleRight(string[] trees, int treeX, int treeY)
{
	int tall = trees[treeY][treeX];
	for (int i = treeX + 1; i < trees[0].Length; i++)
	{
		if (trees[treeY][i] >= tall)
		{
			return i - treeX;
		}
	}
	return trees[0].Length - treeX - 1;
}
