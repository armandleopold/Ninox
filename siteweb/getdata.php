<?php 


$manager = new MongoDB\Driver\Manager("mongodb://172.254.0.4:27017");


$filter = ['value' => ['$gt' => 1]];
$options = [
    'projection' => ['_id' => 0],
    'sort' => ['x' => -1],
];

$query = new MongoDB\Driver\Query($filter, $options);
$cursor = $manager->executeQuery('predictions.data', $query);

$json = array();

foreach ($cursor as $document) {

	array_push($json,$document);
}

echo json_encode($json);



 ?>