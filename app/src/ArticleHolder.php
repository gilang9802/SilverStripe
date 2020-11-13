<?php

namespace SilverStripe\Lessons;

use SilverStripe\Forms\GridField\GridFieldConfig_RecordEditor;
use Page;
use SilverStripe\Forms\GridField\GridField;

class ArticleHolder extends Page{

    private static $has_many = [
        'Categories' => ArticleCategory::class
    ];

    /**
     * CMS Fields
     * @return FieldList
     */
    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        $fields->addFieldsToTab('Root.Categories', GridField::create(
            'Categories',
            'Article categories',
            $this->Categories(),
            GridFieldConfig_RecordEditor::create()
        ));

        return $fields;
    }
}