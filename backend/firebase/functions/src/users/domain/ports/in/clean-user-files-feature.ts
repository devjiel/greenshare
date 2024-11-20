export interface CleanUserFilesResult {
    updatedUsers: string[];
    errors: string[];
}

export interface CleanUserFilesFeature {
    removeFileReferences(fileUid: string): Promise<CleanUserFilesResult>;
}