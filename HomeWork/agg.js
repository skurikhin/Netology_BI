*/
1. count elements
*/

db.tags.count()

*/
2. count elements with 'woman'
*/


db.tags.count({name: 'woman'})

*/
3. top-3 films 

*/
printjson(
db.tags.aggregate 
	([
	{$group: {_id:"$name", tag_count: {$sum: 1}}},
	{$sort: {tag_count: -1}},
	{$limit: 3}
	]) ['_batch']
);
*/ 
result [
	{
		"_id" : "murder",
		"tag_count" : 1308
	},
	{
		"_id" : "independent film",
		"tag_count" : 1930
	},
	{
		"_id" : "woman director",
		"tag_count" : 3115
	}
]
*/
