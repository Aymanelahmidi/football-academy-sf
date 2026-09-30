/**
 * @description HTTP callout mock for Apex tests.
 * Implements HttpCalloutMock to simulate HTTP responses.
 * @author Football Academy Migration
 * @date 2026
 */
@isTest
global class FA_MockHttpCallout implements HttpCalloutMock {
    private Integer statusCode;
    private String body;

    global FA_MockHttpCallout(Integer statusCode, String body) {
        this.statusCode = statusCode;
        this.body = body;
    }

    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setBody(body);
        res.setHeader('Content-Type', 'application/json');
        return res;
    }
}
