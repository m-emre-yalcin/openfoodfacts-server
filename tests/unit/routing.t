#!/usr/bin/perl -w

use Modern::Perl '2017';
use utf8;

use Test2::V0;
use Data::Dumper;
$Data::Dumper::Terse = 1;
use Log::Any::Adapter 'TAP';

use ProductOpener::Routing qw/analyze_request load_routes/;
use ProductOpener::Lang qw/$lc /;

# TODO: create a test case array and use the update_test_results system to
# store and compare the returned $request object

# TODO: add tests for all routes

load_routes();

my @tests = (
	{
		desc => "API to get attribute groups",
		lc => "en",
		input_request => {
			cc => "world",
			lc => "en",
			original_query_string => 'api/v0/attribute_groups',
			no_index => '0',
			is_crawl_bot => '1'
		},
		expected_output_request => {
			'api' => 'v0',
			'api_action' => 'attribute_groups',
			'api_method' => undef,
			'api_version' => '0',
			'cc' => 'world',
			'lc' => 'en',
			'original_query_string' => 'api/v0/attribute_groups',
			'page' => 1,
			'query_string' => 'api/v0/attribute_groups',
			'no_index' => '0',
			'is_crawl_bot' => '1',
			'rate_limiter_blocking' => 0,
			'rate_limiter_limit' => undef,
			'rate_limiter_user_requests' => undef,
			'components' => ['api', 'v0', 'attribute_groups'],
		},
	},
	{
		desc => "Invalid URL with last component which is not a facet or a page number",
		lc => "en",
		input_request => {
			cc => "world",
			lc => "en",
			original_query_string => 'category/breads/no-nutrition-data',
			no_index => '0',
			is_crawl_bot => '0'
		},
		expected_output_request => {
			'api' => 'v0',
			'canon_rel_url' => '/category/en:breads',
			'cc' => 'world',
			'error_message' => 'Invalid address.',
			'lc' => 'en',
			'original_query_string' => 'category/breads/no-nutrition-data',
			'page' => 1,
			'query_string' => 'category/breads/no-nutrition-data',
			'status_code' => 404,
			'tag' => 'en:breads',
			'tag_prefix' => '',
			'tagid' => 'en:breads',
			'tagtype' => 'categories',
			'tags' => [
				{
					'tag' => 'en:breads',
					'tag_prefix' => '',
					'tagid' => 'en:breads',
					'tagtype' => 'categories'
				},
			],
			'param' => {},
			'no_index' => '0',
			'is_crawl_bot' => '0',
			'components' => ['category', 'breads', 'no-nutrition-data'],
			'rate_limiter_blocking' => 0,
			'rate_limiter_limit' => undef,
			'rate_limiter_user_requests' => undef,
		},
	},
	{
		desc => "Facet URL",
		lc => "en",
		input_request => {
			cc => "world",
			lc => "en",
			original_query_string => 'category/breads',
			no_index => '0',
			is_crawl_bot => '1'
		},
		expected_output_request => {
			'api' => 'v0',
			'canon_rel_url' => '/category/en:breads',
			'cc' => 'world',
			'lc' => 'en',
			'original_query_string' => 'category/breads',
			'page' => 1,
			'query_string' => 'category/breads',
			'tag' => 'en:breads',
			'tag_prefix' => '',
			'tagid' => 'en:breads',
			'tagtype' => 'categories',
			'tags' => [
				{
					'tag' => 'en:breads',
					'tag_prefix' => '',
					'tagid' => 'en:breads',
					'tagtype' => 'categories'
				},
			],
			'param' => {},
			'no_index' => '0',
			'is_crawl_bot' => '1',
			'rate_limiter_blocking' => 0,
			'rate_limiter_limit' => undef,
			'rate_limiter_user_requests' => undef,
			'components' => ['category', 'breads'],
		},
	},
	{
		desc => "Facet URL with a page number",
		lc => "en",
		input_request => {
			cc => "world",
			lc => "en",
			original_query_string => 'category/breads/4',
			no_index => '0',
			is_crawl_bot => '1'
		},
		expected_output_request => {
			'api' => 'v0',
			'canon_rel_url' => '/category/en:breads',
			'cc' => 'world',
			'lc' => 'en',
			'original_query_string' => 'category/breads/4',
			'page' => '4',
			'query_string' => 'category/breads/4',
			'tag' => 'en:breads',
			'tag_prefix' => '',
			'tagid' => 'en:breads',
			'tagtype' => 'categories',
			'tags' => [
				{
					'tag' => 'en:breads',
					'tag_prefix' => '',
					'tagid' => 'en:breads',
					'tagtype' => 'categories'
				},
			],
			'param' => {},
			'no_index' => '1',
			'is_crawl_bot' => '1',
			'components' => ['category', 'breads', '4'],
		},
	},
	{
		desc => "Facet URL with a facet synonym and a page number",
		lc => "en",
		input_request => {
			cc => "world",
			lc => "en",
			original_query_string => 'category/bread/4',
			no_index => '0',
			is_crawl_bot => '0'
		},
		expected_output_request => {
			'api' => 'v0',
			'canon_rel_url' => '/category/en:bread',
			'cc' => 'world',
			'lc' => 'en',
			'original_query_string' => 'category/bread/4',
			'page' => '4',
			'query_string' => 'category/bread/4',
			'tag' => 'en:bread',
			'tag_prefix' => '',
			'tagid' => 'en:bread',
			'tagtype' => 'categories',
			'tags' => [
				{
					'tag' => 'en:bread',
					'tag_prefix' => '',
					'tagid' => 'en:bread',
					'tagtype' => 'categories'
				},
			],
			'param' => {},
			'no_index' => '0',
			'is_crawl_bot' => '0',
			'rate_limiter_blocking' => 0,
			'rate_limiter_limit' => undef,
			'rate_limiter_user_requests' => undef,
			'components' => ['category', 'bread', '4'],
		},
	},
	{
		desc => "API v3 URL with product code",
		lc => "en",
		input_request => {
			cc => "world",
			lc => "en",
			original_query_string => 'api/v3/product/03564703999971',
			no_index => '0',
			is_crawl_bot => '0'
		},
		expected_output_request => {
			'api' => 'v3',
			'api_action' => 'product',
			'api_method' => undef,
			'api_version' => '3',
			'cc' => 'world',
			'lc' => 'en',
			'original_query_string' => 'api/v3/product/03564703999971',
			'query_string' => 'api/v3/product/03564703999971',
			'code' => '03564703999971',
			'page' => '1',
			'no_index' => '0',
			'is_crawl_bot' => '0',
			'rate_limiter_blocking' => 0,
			'rate_limiter_limit' => 100,
			'rate_limiter_user_requests' => undef,
			'components' => ['api', 'v3', 'product', '03564703999971'],
		},
	},
	{
		desc => "API v3 URL with product GS1 Data URI",
		lc => "en",
		input_request => {
			cc => "world",
			lc => "en",
			original_query_string =>
				'api/v3/product/https%3A%2F%2Fid.gs1.org%2F01%2F03564703999971%2F10%2FABC%2F21%2F123456%3F17%3D211200',
			no_index => '0',
			is_crawl_bot => '0'
		},
		expected_output_request => {
			'api' => 'v3',
			'api_action' => 'product',
			'api_method' => undef,
			'api_version' => '3',
			'cc' => 'world',
			'lc' => 'en',
			'original_query_string' =>
				'api/v3/product/https%3A%2F%2Fid.gs1.org%2F01%2F03564703999971%2F10%2FABC%2F21%2F123456%3F17%3D211200',
			'query_string' =>
				'api/v3/product/https%3A%2F%2Fid.gs1.org%2F01%2F03564703999971%2F10%2FABC%2F21%2F123456%3F17%3D211200',
			'code' => 'https://id.gs1.org/01/03564703999971/10/ABC/21/123456?17=211200',
			'page' => '1',
			'no_index' => '0',
			'is_crawl_bot' => '0',
			'rate_limiter_blocking' => 0,
			'rate_limiter_limit' => 100,
			'rate_limiter_user_requests' => undef,
			'components' => ['api', 'v3', 'product', 'https://id.gs1.org/01/03564703999971/10/ABC/21/123456?17=211200'],
		},
	},
);

foreach my $test_ref (@tests) {

	# Set $lc global because currently analyze_request uses the global $lc
	$lc = $test_ref->{input_request}{lc};
	analyze_request($test_ref->{input_request});

	is($test_ref->{input_request}, $test_ref->{expected_output_request}) or diag Dumper $test_ref;
}

done_testing();
