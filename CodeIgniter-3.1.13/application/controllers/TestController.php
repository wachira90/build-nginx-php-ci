<?php
defined('BASEPATH') OR exit('No direct script access allowed');

// class TestController extends CI_Controller {

//     public function index()
//     {
//         // Call the CURL function
//         $data['api_response'] = $this->fetch_data();

//         // Load view and pass data
//         $this->load->view('test_view', $data);
//     }

//     private function fetch_data()
//     {
//         // Initialize CURL
//         $curl = curl_init();

//         // Set CURL options
//         curl_setopt_array($curl, array(
//             CURLOPT_URL => "https://jsonplaceholder.typicode.com/todos/",
//             CURLOPT_RETURNTRANSFER => true,
//             CURLOPT_SSL_VERIFYPEER => false, // Ignore SSL verification
//         ));

//         // Execute CURL request
//         $response = curl_exec($curl);

//         // Close CURL session
//         curl_close($curl);

//         return $response;
//     }
// }


class TestController extends CI_Controller {

    public function index($id = null) 
    {
        if ($id === null) {
            show_404(); // Show 404 error if no ID is provided
        }

        // Call the CURL function with the provided ID
        $data['api_response'] = $this->fetch_data($id);

        // Load view and pass data
        $this->load->view('test_view', $data);
    }

    private function fetch_data($id) 
    {
        // Initialize CURL
        $curl = curl_init();

        // Set CURL options
        curl_setopt_array($curl, array(
            CURLOPT_URL => "https://jsonplaceholder.typicode.com/todos/" . $id,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => false, // Ignore SSL verification
        ));

        // Execute CURL request
        $response = curl_exec($curl);

        // Close CURL session
        curl_close($curl);

        return $response;
    }
}
