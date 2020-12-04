<?php

use SilverStripe\ORM\DataObject;

class TransactionDetail extends DataObject{

    private static $db = [
        'Qty' => 'Int',
        'Price' => 'Double',
        'Subtotal' => 'Double',
    ];

    private static $has_one = [
        'Transaction' => Transaction::class,
        'Product' => Product::class,
    ];
}
