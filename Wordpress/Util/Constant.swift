//
//  Constant.swift
//  Wordpress
//
//  Created by Asil Arslan on 27.04.2021.
//

import Foundation
import SwiftUI

var URL_HEADLINE_POSTS = "\(WORDPRESS_URL)/wp-json/wp/v2/posts?_embed&status=publish&categories=\(HEADLINE_CATEGORY_ID)"
var URL_POSTS = "\(WORDPRESS_URL)/wp-json/wp/v2/posts?_embed&status=publish"
var URL_PAGES = "\(WORDPRESS_URL)/wp-json/wp/v2/pages?_embed&status=publish"
var URL_COMMENTS = "\(WORDPRESS_URL)/wp-json/wp/v2/comments"
var URL_POST_COMMENTS = "\(WORDPRESS_URL)/wp-json/wp/v2/comments?status=approve&post="
var URL_CATEGORIES = "\(WORDPRESS_URL)/wp-json/wp/v2/categories?per_page=100&hide_empty=true"
var URL_CATEGORY_POST = "\(WORDPRESS_URL)/wp-json/wp/v2/posts?_embed&status=publish&categories="
var URL_TAGS = "\(WORDPRESS_URL)/wp-json/wp/v2/tags?per_page=100"
var URL_TAG_POST = "\(WORDPRESS_URL)/wp-json/wp/v2/posts?_embed&status=publish"
